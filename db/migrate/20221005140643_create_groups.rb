# frozen_string_literal: true

class CreateGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :groups do |t|
      t.string :title, null: false

      t.timestamps
    end

    create_table :groups_users, id: false do |t|
      t.belongs_to :group
      t.belongs_to :user

      t.timestamps
    end
  end
end
