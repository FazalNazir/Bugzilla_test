# frozen_string_literal: true

class CreateSynchronizationRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :synchronization_records do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :sync_token

      t.timestamps
    end
  end
end
