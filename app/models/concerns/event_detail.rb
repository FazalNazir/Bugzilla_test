# frozen_string_literal: true

module EventDetails
  extend ActiveSupport::Concern

  included do
    def set_event_title
      case eventable_type
        when 'Evaluaton'
          "#{eventable.task.name} #{eventable.re_evaluation ? 'Re-' : ''}Evaluation"
        when 'Sync'
          'Trainee Sync'
      end
    end

    def set_guests_list
      additional_user = User.find(eventable_type == 'Sync' ? eventable.supervisor_id : eventable.evaluator_id).email
      if eventable_type == 'Sync'
        trainees = eventable.trainees.pluck(:email).join(',')
      else
        trainee = eventable.trainee.email
      end
      "#{additional_user}," + (trainee || trainees)
    end
  end
end
