# frozen_string_literal: true

class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :title

      t.timestamps
    end

    create_table :categories_courses, id: false do |t|
      t.belongs_to :category
      t.belongs_to :course

      t.timestamps
    end
  end
end
