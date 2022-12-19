# frozen_string_literal: true

class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications do |t|
      t.string :title, null: false
      t.string :message, null: false
      t.boolean :has_read, default: false
      t.belongs_to :user

      t.timestamps
    end
  end
end
