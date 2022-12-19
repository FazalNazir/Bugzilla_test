# frozen_string_literal: true

class WatchRecord < ApplicationRecord
  belongs_to :user, inverse_of: :watch_record
end
