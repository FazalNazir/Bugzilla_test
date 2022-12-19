# frozen_string_literal: true

# default helpers containing all helpers
module ApplicationHelper
  def dropdown_options
    return super_user_options if current_user&.has_role?(:super_user)

    evaluator_options if current_user&.has_role?(:evaluator)
  end

  def super_user_options
    [
      { name: 'Users', path: users_path },
      { name: 'Roles', path: roles_path },
      { name: 'Departments', path: '#' },
      { name: 'Groups', path: groups_path }
    ]
  end

  def evaluator_options
    [
      { name: 'Schedule', path: evaluations_path },
      { name: 'Free Slots', path: '#' }
    ]
  end
end
