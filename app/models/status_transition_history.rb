# frozen_string_literal: true

class StatusTransitionHistory < ApplicationRecord
  belongs_to :historic, polymorphic: true, inverse_of: :status_transition_histories

  def assign_reason(transition)
    condition = (transition.from == 're_evaluated' || transition.from == 'evaluated') && (transition.to == 'ready')

    return if historic_type != 'Evaluation'

    self.reason = I18n.t(condition ? 'assign_re_evaluation' : transition.event.to_s,
                         trainee: historic.trainee.name,
                         evaluator: historic.evaluator.name,
                         task: historic.task.name)
  end
end
