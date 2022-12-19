# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: Rails.application.credentials.dig(:gmail, :username)
  layout 'mailer'
end
