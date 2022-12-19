# frozen_string_literal: true

class CreateCourses < ActiveRecord::Migration[7.0]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :created_by

      t.timestamps
    end
  end
end
