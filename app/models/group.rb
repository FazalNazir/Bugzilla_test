# frozen_string_literal: true

class Group < ApplicationRecord
  include Bulkable

  has_many :groups_users, dependent: :delete_all
  has_many :users, through: :groups_users

  validates :title, presence: true

  delegate :count, to: :users, prefix: true
end
