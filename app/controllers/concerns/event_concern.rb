# frozen_string_literal: true

module EventConcern
  extend ActiveSupport::Concern
  def verify_token
    @watch_record = WatchRecord.where(external_id: params[:id] || request.headers['HTTP_X_GOOG_CHANNEL_ID'],
                                      token: params[:token] || request.headers['HTTP_X_GOOG_CHANNEL_TOKEN']).first
    redirect_to(syncs_path, alert: 'Could not refresh', status: 498) if @watch_record.nil? && current_user.nil?
  end

  # def send_notification_for_logged_user
  #   @record.id && NotificationManager
  #     .create_notification_for_single_user(current_user, 'Synchronization Complete!',
  #                                          "Your calendar was synchronized at #{@record.updated_at
  #                                          .in_time_zone(TIME_ZONE).strftime('%d-%b-%Y ; %I:%M %p')}")
  # end

  # def send_notification(users)
  #   if current_user
  #     send_notification_for_logged_user
  #   else
  #     send_notification_for_multiple_users(users)
  #   end
  # end

  # def send_notification_for_multiple_users(users)
  #   users.each do |user|
  #     NotificationManager
  #       .create_notification_for_single_user(user, 'Synchronization Complete!',
  #                                            "Your calendar was synchronized at #{@record.updated_at
  #                                            .in_time_zone(TIME_ZONE).strftime('%d-%b-%Y ; %I:%M %p')}")
  #   end
  # end
end
