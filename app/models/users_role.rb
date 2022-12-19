# frozen_string_literal: true

class UsersRole < ApplicationRecord
  belongs_to :role
  belongs_to :user
end
