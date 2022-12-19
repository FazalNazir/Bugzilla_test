# frozen_string_literal: true

# contains helpers for pages controller
module PagesHelper
  def all_user_roles(user)
    user.roles.pluck(:name).join(', ')
  end
end
