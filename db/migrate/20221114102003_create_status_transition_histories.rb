# frozen_string_literal: true

class CreateStatusTransitionHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :status_transition_histories do |t|
      t.string :from, null: false
      t.string :to, null: false
      t.string :event, null: false
      t.string :reason, null: false
      t.references :historic, polymorphic: true

      t.timestamps
    end
  end
end
