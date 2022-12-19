# frozen_string_literal: true

class Course < ApplicationRecord
  has_many :users, through: :enrollments
  has_many :enrollments, dependent: :destroy
  has_many :sections, dependent: :destroy
  has_many :tasks, through: :sections
  has_and_belongs_to_many :categories

  validates :title, presence: true

  scope :associated_projects, -> (course_ids) do
    joins(:categories).where(id: course_ids).select('categories.id').distinct
  end

  def duration
    sections.pluck(:days).sum
  end
end
