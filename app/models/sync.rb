# frozen_string_literal: true

class Sync < ApplicationRecord
  belongs_to :supervisor, class_name: 'User', inverse_of: :supervisor_syncs
  has_one :event, as: :eventable, dependent: :destroy, inverse_of: :eventable
  has_many :trainees, class_name: :User, dependent: :nullify, inverse_of: :sync
  has_many :feedbacks, as: :feedbackable, dependent: :destroy
  accepts_nested_attributes_for :event
  accepts_nested_attributes_for :trainees

  scope :on_date, -> (date) do
    joins(:event).where(events: { start_date: date.to_date&.all_day })
  end

  def start_time
    event.start_date
  end

  def assign_trainees(ids)
    trainees << User.in_bulk(ids)
  end

  def create_calendar_event(user)
    trainees_emails = Mapper.map_trainees(self)
    calendar_event = Calendar.get_event(Mapper.map_event(event, ("#{supervisor.email}," + trainees_emails),
                                                         title: event.title.empty? ? 'Trainee Sync' : event.title))
    Calendar.use_client(user) do |client, _logged_user|
      calendar_event = client.insert_event('primary', calendar_event, send_updates: 'all')
    end
    event.external_id = calendar_event.id
  end
end
