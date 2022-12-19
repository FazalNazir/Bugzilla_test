# frozen_string_literal: true

class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.belongs_to :section, index: true, foreign_key: true
      t.integer :duration
      t.string :description

      t.timestamps
    end
  end
end
