# frozen_string_literal: true

# controller for different users
class UsersController < ApplicationController
  include UserConcern
  include CommonConcern
  before_action :authorize_user!, :search_query, :map_params
  before_action :set_user, only: %i[update destroy edit]
  before_action :set_bulk_users, only: %i[bulk_update bulk_destroy]
  before_action :set_selected_menus, only: :index

  def index
    @users = @query.result(distinct: true)
    set_evaluations_and_evaluators
    @users = ((params[:from] && @users.with_any_roles(FILTER_ROLES[params[:from]])) || @users)
             .paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.create(create_params.except(:roles))
    @user.update_roles(create_params[:roles].split(','))
    add_flash(@user.id, 'User created succesfully', 'Could not create user.')
    set_all_users
  end

  def update
    update_user
    set_all_users
  end

  def bulk_update
    update_user
    set_all_users
    render 'update'
  end

  def destroy
    add_flash(@user.destroy, 'User has been destroyed successfuly.', 'Could not delete the selected user.')
    set_all_users
    render 'create'
  end

  def bulk_destroy
    destroy_bulk_users
    add_flash(true, 'Users have been destroyed successfuly.', 'Could not delete the selected users.')
    set_all_users
    render 'create'
  end

  private

    def id
      params.require(:id)
    end

    def ids
      params.require(:ids)
    end

    def create_params
      params.require(:user).permit(:name, :password, :active, :email, :password_confirmation, :roles)
    end

    def update_params
      params.require(:user).permit(:group_ids, :name, :password, :password_confirmation, :active, :email)
    end

    def set_user
      @user = User.find_by(id: id)
    end

    def set_bulk_users
      @users = User.in_bulk(ids)
    end

    def set_all_users
      @users = User.order(created_at: :asc).paginate(page: params[:page])
    end

    def filter_params
      params.permit(:query, :date, :select)
    end

    def authorize_user!
      authorize(@user || User)
    end
end
