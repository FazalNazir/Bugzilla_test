# frozen_string_literal: true

# controller for managing roles
class RolesController < ApplicationController
  include CommonConcern
  before_action :set_selected_menus, only: :index
  before_action :set_all_roles, only: %i[index create]

  def index; end

  def new
    @role = Role.new
  end

  def create
    add_flash(Role.create(create_params), 'Role was created successfuly', 'Could not create Role')
  end

  def destroy
    @roles = Role.in_bulk(id, { locked: [false, nil] })
    add_flash(!@roles.size.zero? && @roles.destroy_all, 'role(s) destroyed successfuly.', 'Could not destroy role(s).')
    set_all_roles
  end

  private

    def set_all_roles
      @roles = @query.result(distinct: true).where.not(name: :super_user).paginate(page: params[:page])
    end

    def create_params
      params[:role][:name] = params[:role][:name].parameterize.underscore.to_sym
      params.require(:role).permit(:name, :description)
    end

    def set_selected_menus
      @active = 'ic-user'
      @sub_active = 'Roles'
      @heading = 'Manage Users'
    end
end
