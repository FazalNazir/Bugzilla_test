# frozen_string_literal: true

class CreateFeedbacks < ActiveRecord::Migration[7.0]
  def change
    create_table :feedbacks do |t|
      t.references :feedbackable, polymorphic: true

      t.timestamps
    end
  end
end
