# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :events do |t|
      t.string :external_id
      t.datetime :start_date
      t.datetime :end_date
      t.string :title
      t.string :location
      t.string :description
      t.references :eventable, polymorphic: true
      t.integer :recur_every
      t.integer :recur_by
      t.references :parent, foreign_key: { to_table: :events }
      t.integer :count
      t.integer :color_id

      t.timestamps
    end
  end
end
