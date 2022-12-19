# frozen_string_literal: true

class Role < ApplicationRecord
  include Bulkable

  belongs_to :resource,
             polymorphic: true,
             optional: true

  has_many :users_roles, dependent: :delete_all
  has_many :users, through: :users_roles

  validates :resource_type,
            inclusion: { in: Rolify.resource_types },
            allow_nil: true
  validates :name, presence: true, uniqueness: true

  scopify

  delegate :count, to: :users, prefix: true

  def stylize
    name.humanize.titleize
  end
end
