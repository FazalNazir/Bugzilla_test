# frozen_string_literal: true

class CreateEnrollments < ActiveRecord::Migration[7.0]
  def change
    create_table :enrollments do |t|
      t.belongs_to :user
      t.belongs_to :course
      t.datetime :start_date
      t.datetime :due_date

      t.timestamps
    end
  end
end
