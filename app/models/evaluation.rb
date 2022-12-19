# frozen_string_literal: true

class Evaluation < ApplicationRecord
  belongs_to :enrollment
  belongs_to :evaluator, class_name: :User, optional: true
  belongs_to :task
  has_one :event, as: :eventable, dependent: :destroy
  has_many :status_transition_histories, as: :historic, dependent: :destroy
  has_many :feedbacks, as: :feedbackable, dependent: :destroy

  validate :evaluator_assigned, on: :update, if: :request?

  def trainee
    enrollment.user
  end

  state_machine :status, initial: :request do
    around_transition do |evaluation, transition, block|
      Evaluation.transaction do
        previous_status = evaluation.status
        block.call
        if transition.to == evaluation.status && evaluation.status != previous_status
          history = evaluation.status_transition_histories.build(from: transition.from,
                                                                 to: transition.to, event: transition.event)
          history.assign_reason(transition) && history.save
        end
      end
    end

    after_transition on: :evaluator_reject, do: :evaluator_rejection

    event :accept do
      transition request: :ready, if: %i[associations_assigned? save]
    end

    event :reject do
      transition request: :rejected
    end

    event :evaluate do
      transition ready: :evaluated
    end

    event :re_evaluate do
      transition evaluated: :ready, ready: :re_evaluated, re_evaluated: :ready
    end

    event :complete do
      transition re_evaluated: :done, evaluated: :done
    end

    event :requested do
      transition rejected: :request
    end

    event :evaluator_reject do
      transition ready: :request
    end
  end

  def evaluator_rejection
    event.update(start_date: :nil, end_date: :nil, location: '')
  end

  def associations_assigned?
    !evaluator_id.nil? && !event.external_id.nil?
  end

  def evaluation_date
    event&.start_date
  end

  def evaluator_assigned
    return true unless evaluator_id.nil?

    errors.add(:evaluator_id, 'Assign evaluator.')
  end

  def create_calendar_event(user)
    calendar_event = Calendar.get_event(Mapper.map_event(event, "#{evaluator.email},#{trainee.email}",
                                                         title: "#{task.name} #{re_evaluation ? 'Re-' : ''}Evaluation"))
    Calendar.use_client(user) do |client, _logged_user|
      calendar_event = if event.id && event.external_id
                         update_calendar_event(calendar_event, client, event.external_id)
                       else
                         client.insert_event('primary', calendar_event, send_updates: 'all')
                       end
    end
    event.external_id = calendar_event.id
  end

  def update_calendar_event(calendar_event, client, id)
    event = client.get_event('primary', id)
    event = Calendar.get_updated_event(event, calendar_event)
    client.update_event('primary', id, event, send_updates: 'all')
  end
end
