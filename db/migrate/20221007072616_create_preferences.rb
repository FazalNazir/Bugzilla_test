# frozen_string_literal: true

class CreatePreferences < ActiveRecord::Migration[7.0]
  def change
    create_table :preferences do |t|
      t.boolean :dark_mode, default: false
      t.string :calendar_name, default: 'primary'
      t.belongs_to :user

      t.timestamps
    end
  end
end
