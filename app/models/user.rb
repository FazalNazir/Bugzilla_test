# frozen_string_literal: true

class User < ApplicationRecord
  include Bulkable
  rolify

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:google_oauth2]

  belongs_to :sync, -> { where(roles: { name: :trainee }) }, inverse_of: :trainees, optional: true
  has_one :preference, dependent: :destroy
  has_one :watch_record, dependent: :destroy, inverse_of: :user
  has_one :synchronization_record, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments
  has_many :slots, dependent: :destroy
  has_many :evaluated_evaluations, class_name: :Evaluation, foreign_key: 'evaluator_id', dependent: :destroy,
                                   inverse_of: :evaluator
  has_many :evaluations, through: :enrollments, dependent: :destroy
  has_many :supervisor_syncs, class_name: :Sync, foreign_key: 'supervisor_id', dependent: :destroy,
                              inverse_of: :supervisor
  has_many :groups_users, dependent: :delete_all
  has_many :groups, through: :groups_users, dependent: :destroy

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true

  after_create :assign_default_role
  after_create :assign_default_group
  after_create :assign_preference

  delegate :count, to: :roles, prefix: true

  scope :with_any_roles, -> (names) { joins(:roles).where(roles: { name: names }).distinct }
  scope :with_groups, -> (grps) { joins(:groups).where(groups: { id: grps }) }

  def update_roles(roles_param)
    roles_param.each do |role|
      add_role(role.to_sym) unless has_role?(role.to_sym)
    end
    roles.each do |role|
      remove_role(role.name.to_sym) unless roles_param.include?(role.name)
    end
  end

  def all_notifications
    notifications.order(created_at: :desc)
  end

  def any_unread_notifications?
    notifications.exists?(has_read: false)
  end

  def group?(g_id)
    groups.find_by(id: g_id)
  end

  def assign_default_role
    add_role(:trainee) if roles.blank?
  end

  def assign_default_group
    groups << Group.first if groups.count.zero?
  end

  def dark_mode?
    preference.dark_mode
  end

  def assign_preference
    create_preference(dark_mode: false)
  end

  def enroll(course, start_date, due_date)
    (courses << course) && enrollments.where(course_id: course.id).first.update(start_date: start_date,
                                                                                due_date: due_date)
  end

  def active_for_authentication?
    super && active
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(email: data['email']).first
    user ||= User.create(name: data['name'],
                         email: data['email'],
                         password: Devise.friendly_token[0, 20])
    user
  end

  def all_time_slots(date)
    arr = []
    slots.where('slots.date=? or slots.day=? or recurrent=?', date.to_date, date.to_date.strftime('%a'),
                1).find_each do |slot|
      arr << { slot: "#{slot.start_time.strftime('%H:%M')}-#{slot.end_time.strftime('%H:%M')}",
               slot_id: slot.id }
    end
    arr
  end
end
