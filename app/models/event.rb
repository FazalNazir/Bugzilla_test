# frozen_string_literal: true

class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true
  belongs_to :parent, class_name: :Event, inverse_of: :occurences, optional: true
  has_many :occurences, class_name: :Event, foreign_key: :parent_id, dependent: :destroy, inverse_of: :parent
  validates :external_id, presence: true
  after_commit :create_occurences, if: :recur?, on: %i[create update]

  enum recur_by: {
    'SINGLE' => 0,
    'DAILY' => 1,
    'WEEKLY' => 2
  }

  def create_occurences
    (count || 5).times do |i|
      event = dup
      event = Mapper.map_occurence(event, i + 1)
      event.count = i
      event.parent_id = id
      event.save
    end
  end

  def recur?
    recur_by != 'SINGLE' && recur_by.present? && recur_every.present? && parent_id.nil?
  end
end
