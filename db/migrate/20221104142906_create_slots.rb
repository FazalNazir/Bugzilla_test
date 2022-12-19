# frozen_string_literal: true

class CreateSlots < ActiveRecord::Migration[7.0]
  def change
    create_table :slots do |t|
      t.date :date
      t.string :day
      t.time :start_time
      t.time :end_time
      t.integer :recurrent
      t.belongs_to :user

      t.timestamps
    end
  end
end
