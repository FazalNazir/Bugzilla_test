# frozen_string_literal: true

class Enrollment < ApplicationRecord
  belongs_to :user, inverse_of: :enrollments
  belongs_to :course, inverse_of: :enrollments

  has_many :evaluations, dependent: :destroy
end
