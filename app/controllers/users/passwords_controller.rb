# frozen_string_literal: true

module Users
  # Contains Customized devise action for turbo stream
  class PasswordsController < Devise::PasswordsController
    layout 'devise'
    skip_before_action :navbar_options
    # GET /resource/password/new
    # def new
    #   super
    # end

    # POST /resource/password
    def create
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      yield resource if block_given?
      if successfully_sent?(resource)
        set_flash_message(:send_instructions, :notice)
      else
        flash[:alert] = 'Email does not exist.'
      end
    end

    # GET /resource/password/edit?reset_password_token=abcdef
    # def edit
    #   super
    # end

    # PUT /resource/password
    def update
      self.resource = resource_class.reset_password_by_token(resource_params)
      @resource_obj = resource
      yield resource if block_given?

      if resource.errors.empty?
        resource.unlock_access! if unlockable?(resource)
        if Devise.sign_in_after_reset_password
          flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
          set_flash_message!(:notice, flash_message)
          resource.after_database_authentication
          sign_in(resource_name, resource)
        else
          set_flash_message!(:notice, :updated_not_active)
        end
      else
        set_minimum_password_length
        respond_with resource
      end
    end

    # protected

    # def after_resetting_password_path_for(resource)
    #   super(resource)
    # end

    # The path used after sending reset password instructions
    # def after_sending_reset_password_instructions_path_for(resource_name)
    #   super(resource_name)
    # end
  end
end
