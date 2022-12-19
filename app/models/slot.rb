# frozen_string_literal: true

class Slot < ApplicationRecord
  belongs_to :user

  enum recurrent: {
    single: 0,
    daily: 1,
    weekly: 2,
    monthly: 3
  }
end
