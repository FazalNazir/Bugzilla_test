# frozen_string_literal: true

require 'google/api_client/client_secrets'

class Calendar
  def self.get_event(task)
    event = Google::Apis::CalendarV3::Event.new(
      summary: task[:title],
      location: task[:location],
      description: task[:description],
      start: {
        date_time: task[:startDate].rfc3339,
        time_zone: 'Asia/Karachi'
      },
      end: {
        date_time: task[:endDate].rfc3339,
        time_zone: 'Asia/Karachi'
      },
      attendees: Mapper.map_attendees(task[:members]),
      reminders: {
        use_default: false,
        overrides: [
          Google::Apis::CalendarV3::EventReminder.new(reminder_method: 'popup', minutes: 10),
          Google::Apis::CalendarV3::EventReminder.new(reminder_method: 'email', minutes: 20)
        ]
      },
      notification_settings: {
        notifications: [
          { type: 'event_creation', method: 'email' },
          { type: 'event_change', method: 'email' },
          { type: 'event_cancellation', method: 'email' },
          { type: 'event_response', method: 'email' }
        ]
      },
      primary: true
    )
    event.recurrence = [task[:rule]] if task[:rule]
    event.color_id = task[:color_id] if task[:color_id]
    event
  end

  def self.get_updated_event(event, calendar_event)
    event.summary = calendar_event.summary
    event.description = calendar_event.location
    event.location = calendar_event.description
    event.start = calendar_event.start
    event.end = calendar_event.end
    event.attendees = calendar_event.attendees
    event
  end

  def self.get_calendar_list(user)
    Calendar.use_client(user) do |client, _logged_user|
      client.list_calendar_lists
    end
  end

  def self.get_google_calendar_client(user)
    client = Google::Apis::CalendarV3::CalendarService.new
    secrets = Google::APIClient::ClientSecrets.new(
      {
        'web' => {
          'access_token' => user.access_token,
          'refresh_token' => user.refresh_token,
          'client_id' => Rails.application.credentials[Rails.env.to_sym][:GOOGLE_CLIENT_ID],
          'client_secret' => Rails.application.credentials[Rails.env.to_sym][:GOOGLE_CLIENT_SECRET]
        }
      }
    )
    begin
      client.authorization = secrets.to_authorization
      refresh_access_token(client, user) unless user.expires_at.present? && user.expires_at > DateTime.now
    rescue StandardError => _e
      flash[:error] = 'Your token has been expired. Please login again with google.'
      redirect_to(:back)
    end
    client
  end

  def self.refresh_access_token(client, user)
    client.authorization.grant_type = 'refresh_token'
    return if user.blank?

    client.authorization.refresh!
    user.update(
      access_token: client.authorization.access_token,
      refresh_token: client.authorization.refresh_token,
      expires_at: Time.zone.at(client.authorization.expires_at).to_datetime
    )
  end

  def self.use_client(user)
    client = Calendar.get_google_calendar_client(user)
    retries = 0
    begin
      yield(client, user)
    rescue Google::Apis::AuthorizationError => _e
      Calendar.refresh_access_token(client, user)
      retry if (retries += 1) == 1
    end
  end

  def self.remove_calendar_event(user, evaluation)
    Calendar.use_client(user) do |client, _logged_user|
      client.delete_event('primary', evaluation.event.external_id)
      evaluation.event.destroy
    end
  end

  def self.synchronize(events)
    events.each do |event|
      event_data = Mapper.map_event_for_synchronization(event)
      title = event_data[:title]&.parameterize
      saved_event = Event.includes(:occurences).where(external_id: event.id).first
      next unless title&.include?('sync') || saved_event.present?

      user_emails = event&.attendees&.map(&:email) || []
      event&.organizer&.email && user_emails.push(event.organizer.email)
      supervisor = User.joins(:roles).where(email: user_emails, roles: { name: :training_supervisor }).first
      trainees = User.joins(:roles).where(email: user_emails, roles: { name: :trainee }).order(created_at: :asc)
      sync = saved_event&.eventable
      if saved_event.present?
        case event.status
          when 'confirmed'
            update_event(saved_event, event_data, trainees, supervisor)
          else
            sync&.destroy || saved_event&.destroy
        end
      else
        sync = Sync.create(supervisor_id: supervisor.id)
        sync.create_event(event_data)
        sync.trainees << trainees if trainees.exists?
      end
    end
  end

  def self.update_event(saved_event, event_data, trainees, supervisor)
    saved_event.occurences.destroy_all
    saved_event.update(event_data)
    sync = saved_event.eventable
    existing_trainees = sync.trainees
    (trainees - existing_trainees).each do |trainee|
      trainee.update(sync_id: sync.id)
    end
    (existing_trainees - trainees).each do |trainee|
      trainee.update(sync_id: nil)
    end
    sync.update(supervisor_id: supervisor.id) unless sync.supervisor_id == supervisor.id
  end
end
