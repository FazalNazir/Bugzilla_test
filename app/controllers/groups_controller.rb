# frozen_string_literal: true

# controller for different groups
class GroupsController < ApplicationController
  include CommonConcern
  before_action :set_all_groups, only: %i[index create]
  before_action :set_selected_menus, only: :index

  def index; end

  def new
    @group = Group.new
  end

  def create
    @group = Group.create(create_params)
    add_flash(@group.id, 'Group Created successfuly', 'Could not created group.')
  end

  def destroy
    @groups = Group.in_bulk(id)
    add_flash(@groups.destroy_all, 'Groups destroyed successfuly.', 'Could not destroy groups.')
    set_all_groups
    render 'create'
  end

  private

    def set_all_groups
      @groups = @query.result(distinct: true).paginate(page: params[:page])
    end

    def create_params
      params.require(:group).permit(:title)
    end

    def set_selected_menus
      @active = 'ic-user'
      @sub_active = 'Groups'
      @heading = 'Manage Users'
    end
end
