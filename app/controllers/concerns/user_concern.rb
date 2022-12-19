# frozen_string_literal: true

module UserConcern
  extend ActiveSupport::Concern

  def update_user
    case params[:from]
      when 'modal'
        update_user_in_case_modal
      when 'status'
        update_user_in_case_status
      when 'group'
        update_user_in_case_group
    end
  end

  def update_user_in_case_status
    if @users
      User.transaction do
        @users.each do |user|
          user.update(update_params)
        end
      end
      flash[:notice] = 'Users have been updated successfuly!'
    else
      @user.update(update_params)
      flash[:notice] = 'User has been updated successfuly!'
    end
  end

  def update_user_in_case_modal
    @user.update_roles(create_params[:roles].split(','))
    @user.update(update_params)
    flash[:notice] = 'User has been updated successfuly!'
  end

  def update_user_in_case_group
    @group = Group.find(update_params[:group_ids])
    return if @user.group?(@group.id)

    add_flash(@user.groups << @group, 'Record has been updated successfuly.',
              'Record was not updated.')
  end

  def set_evaluations_and_evaluators
    return unless filter_params[:select] == 'slot'

    @users = @users.with_any_roles(:evaluator).joins(:slots)
                   .where('slots.date=? or slots.day=? or recurrent=?', filter_params[:date].to_date,
                          filter_params[:date].to_date.strftime('%a'), 1)
    @evaluation = Evaluation.find(params[:evaluation_id])
  end

  def set_selected_menus
    @active = 'ic-user'
    @sub_active = 'Users'
    @heading = 'Manage Users'
  end

  def map_params
    params[:user] && params[:user][:active] != 'true' &&
      params[:user][:active] != 'false' && params[:user][:active] = params[:user][:active] == '1'
    params[:user].delete(:password) if params&.[](:user)&.[](:password) == ''
    params[:user][:password_confirmation] = params[:user][:password] if params&.[](:user)&.[](:password)
  end

  def destroy_bulk_users
    User.transaction do
      @users.each(&:destroy)
    end
  end
end
