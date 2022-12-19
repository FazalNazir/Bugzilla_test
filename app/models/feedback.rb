# frozen_string_literal: true

class Feedback < ApplicationRecord
  has_rich_text :content
  belongs_to :feedbackable, polymorphic: true
end
