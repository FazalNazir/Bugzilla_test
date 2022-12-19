# frozen_string_literal: true

class NotificationsController < ApplicationController
  def read
    @notifications = current_user.notifications.order(created_at: :desc).first(20)
    Notification.transaction do
      current_user.notifications.each do |notification|
        notification.update(has_read: true)
      end
    end
  end
end
