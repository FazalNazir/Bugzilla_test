# frozen_string_literal: true

module CommonConcern
  extend ActiveSupport::Concern
  CONTROLLER = {
    courses: Course,
    roles: Role,
    groups: Group,
    users: User,
    categories: Category,
    enrollments: Enrollment,
    sections: Section,
    evaluations: Evaluation,
    syncs: Sync,
    tasks: Task
  }.freeze

  included do
    before_action :search_query, unless: -> { params[:controller].include?('users/') }
  end

  def id
    params.require(:id)
  end

  def search_query
    @query = CONTROLLER[params[:controller].to_sym].ransack(params[:query])
  end

  def support_options
    return SUPER_USER_OPTIONS if current_user&.has_role?(:super_user)
    return TRAINER_OPTIONS if current_user&.has_role?(:evaluator)

    TRAINEE_OPTIONS
  end
end
