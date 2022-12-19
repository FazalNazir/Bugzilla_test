# frozen_string_literal: true

class CreateWatchRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :watch_records do |t|
      t.string :external_id, null: false
      t.string :resource_id, null: false
      t.string :resource_uri, null: false
      t.string :token, null: false
      t.datetime :expiration, null: false
      t.belongs_to :user, index: true, foreign_key: true
      t.timestamps
    end
  end
end
