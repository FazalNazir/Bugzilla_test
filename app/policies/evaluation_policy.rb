# frozen_string_literal: true

class EvaluationPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      user.has_role?(:evaluator)

      scope.where(evaluator_id: user.id)
    end
  end

  def access_control?
    user.has_role?(:evaluator)
  end
  alias index? access_control?
end
