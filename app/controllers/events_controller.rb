# frozen_string_literal: true

class EventsController < ApplicationController
  include EventConcern
  skip_before_action :authenticate_user!, :verify_authenticity_token, on: :synchronize

  def watch
    if current_user.watch_record.present? && current_user.watch_record.expiration > DateTime.now
      flash[:notice] = 'Calendar changes are being watched already!'
      return
    end

    Calendar.use_client(current_user) do |client, logged_user|
      uri = URI('https://www.googleapis.com/calendar/v3/calendars/primary/events/watch')
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      req = Net::HTTP::Post.new(uri.path)
      body = {
        id: "LND-USER-#{logged_user.id}-WATCH-CHANNEL-ID",
        type: 'web_hook',
        address: synchronize_events_url,
        token: "LND-USER-#{logged_user.id}-WATCH-CHANNEL-TOKEN",
        expiration: 1.week.from_now.to_i * 1000
      }
      req.body = body.to_json
      req['Authorization'] = "Bearer #{client.authorization.access_token}"
      req['Content-Type'] = 'application/json'
      res = https.request(req)
      body = JSON.parse(res.body)
      current_user.create_watch_record(Mapper.map_watch_record(body)) unless body.key?('error')
      add_flash(!body.key?('error'), 'Calendar is being watched for any changes', body&.[]('error')&.[]('message'))
    end
  end

  def synchronize
    verify_token
    Calendar.use_client(current_user || @watch_record.user) do |client, logged_user|
      sync_token = logged_user&.synchronization_record&.sync_token
      time_min = sync_token.nil? ? DateTime.now - 1.month : nil
      time_max = sync_token.nil? ? DateTime.now + 1.month : nil
      res = nil
      while res&.next_sync_token.nil? || !res
        res = client.list_events('primary', page_token: res&.next_page_token, sync_token: sync_token,
                                            time_min: time_min, time_max: time_max, max_results: 5)
        Calendar.synchronize(res.items)
      end
      @record = logged_user.create_synchronization_record(sync_token: res.next_sync_token)
      add_flash(@record.id, 'Synchronization Complete!', '')
    end
  end
end
