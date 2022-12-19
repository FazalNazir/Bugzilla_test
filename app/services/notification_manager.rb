# frozen_string_literal: true

class NotificationManager
  def self.broadcast_to_single_user(user, msg)
    NotificationsChannel.broadcast_to(
      user,
      msg
    )
  end

  def self.create_notification_for_single_user(user, title, message)
    user.notifications.create(title: title, message: message)
    broadcast_to_single_user(user, { title: title, message: message })
  end
end
