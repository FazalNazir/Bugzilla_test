# frozen_string_literal: true

class Mapper
  def self.enrollment_mapping(users, courses, start_date)
    arr = []
    users.each do |user|
      courses.each do |course|
        arr << { course_id: course.id, start_date: start_date, user_id: user.id, due_date: start_date + course.duration }
      end
    end
    arr
  end

  def self.map_accepted_status(params)
    if params[:query][:status_eq_any]&.include?('accepted')
      return params[:query][:status_eq_any] - ['accepted'] + %w[ready done evaluated re_evaluated]
    end

    params[:query][:status_eq_any]
  end

  def self.map_attendees(attendees)
    attendees.split(',').map { |t| { email: t.strip } }
  end

  def self.map_event(event, members, title: nil)
    {
      members: members,
      title: title || event.title,
      location: event.location,
      description: event.description,
      startDate: event.start_date,
      endDate: event.end_date,
      rule: event.recur_by && event.recur_by != 'SINGLE' && "RRULE:FREQ=#{event.recur_by};INTERVAL=#{event.recur_every};COUNT=10",
      color_id: event.color_id
    }
  end

  def self.map_trainees(sync)
    trainees = sync.trainees
    trainees.map(&:email).join(',')
  end

  def self.map_occurence(event, index)
    event.start_date = event.start_date + (event.recur_every * index).method(event.recur_by == 'DAILY' ? 'day' : 'week').call.in_days.days
    event.end_date = event.end_date + (event.recur_every * index).method(event.recur_by == 'DAILY' ? 'day' : 'week').call.in_days.days
    event
  end

  def self.map_watch_record(data)
    {
      external_id: data['id'],
      resource_id: data['resourceId'],
      resource_uri: data['resourceUri'],
      token: data['token'],
      expiration: Time.zone.at(data['expiration'].to_i / 1000).to_datetime
    }
  end

  def self.map_event_for_synchronization(event)
    rule = {}
    rule_arguments = event&.recurrence&.[](0)&.remove('RRULE:')
    rule_arguments&.split(/[;,:]/)&.each do |argument|
      values = argument.split('=')
      rule[values[0].to_sym] = values[1]
    end
    {
      description: event&.description,
      start_date: event&.start&.date_time,
      end_date: event&.end&.date_time,
      location: event&.location,
      external_id: event&.id,
      title: event&.summary,
      recur_by: rule&.[](:FREQ),
      recur_every: rule&.[](:INTERVAL) || (rule&.[](:FREQ).present? ? 1 : nil),
      count: rule&.[](:COUNT)
    }
  end
end
