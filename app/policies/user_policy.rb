# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all if user.has_role?(:super_user)
    end
  end

  def access_control?
    user.has_role?(:super_user)
  end

  def show?
    true
  end

  alias index? access_control?
  alias new? access_control?
  alias create? access_control?
  alias admin_new? access_control?
  alias admin_create? access_control?
  alias edit? access_control?
  alias update? access_control?
  alias destroy? access_control?
  alias filter? access_control?
  alias bulk_update? access_control?
  alias bulk_destroy? access_control?
end
