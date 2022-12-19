# frozen_string_literal: true

class Section < ApplicationRecord
  belongs_to :course
  has_many :tasks, dependent: :destroy
  has_rich_text :description

  validates :title, presence: true
  validates :days, presence: true, numericality: { greater_than_or_equal_to: 1 }
end
