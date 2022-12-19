# frozen_string_literal: true

class CreateSections < ActiveRecord::Migration[7.0]
  def change
    create_table :sections do |t|
      t.string :title
      t.belongs_to :course, index: true, foreign_key: true
      t.integer :days

      t.timestamps
    end
  end
end
