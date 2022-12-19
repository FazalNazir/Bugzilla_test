# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < Devise::OmniauthCallbacksController
    skip_before_action :navbar_options
    # You should configure your model like this:
    # devise :omniauthable, omniauth_providers: [:twitter]

    def google_oauth2
      @user = User.from_omniauth(request.env['omniauth.auth'])
      if @user.persisted?
        flash[:notice] = I18n.t('devise.omniauth_callbacks.success', kind: 'Google')
        auth = request.env['omniauth.auth']
        @user.access_token = auth.credentials.token
        @user.expires_at = Time.zone.at(auth.credentials.expires_at).to_datetime
        @user.refresh_token = auth.credentials.refresh_token if auth.credentials.refresh_token
        @user.save!
        sign_in(@user)
        redirect_to(super_user_root_path(format: :html))
      else
        session['devise.google_data'] = request.env['omniauth.auth']
        redirect_to(new_user_session_url)
      end
    end

    # You should also create an action method in this controller like this:
    # def twitter
    # end

    # More info at:
    # https://github.com/heartcombo/devise#omniauth

    # GET|POST /resource/auth/twitter
    # def passthru
    #   super
    # end

    # GET|POST /users/auth/twitter/callback
    # def failure
    #   super
    # end

    # protected

    # The path used when OmniAuth fails
    # def after_omniauth_failure_path_for(scope)
    #   super(scope)
    # end
  end
end
