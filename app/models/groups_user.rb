# frozen_string_literal: true

class GroupsUser < ApplicationRecord
  belongs_to :group
  belongs_to :user
end
