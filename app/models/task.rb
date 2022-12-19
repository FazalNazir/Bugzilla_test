# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :section
  has_many :evaluations, dependent: :destroy

  validates :name, presence: true

  def pending_evaluations(statuses)
    evaluations.where(status: statuses).count
  end
end
