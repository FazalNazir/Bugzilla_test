# frozen_string_literal: true

module Users
  # contins cutomized session related actions
  class SessionsController < Devise::SessionsController
    layout 'devise'
    skip_before_action :navbar_options
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end

    private

      def respond_to_on_destroy
        respond_to do |format|
          format.all { redirect_to(super_user_root_path(format: :html)) }
        end
      end
  end
end
