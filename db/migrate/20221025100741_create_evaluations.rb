# frozen_string_literal: true

class CreateEvaluations < ActiveRecord::Migration[7.0]
  def change
    create_table :evaluations do |t|
      t.references :evaluator, foreign_key: { to_table: 'users' }
      t.references :enrollment, index: true, foreign_key: true
      t.belongs_to :task, index: true, foreign_key: true
      t.boolean :re_evaluation, default: false
      t.string :status

      t.timestamps
    end
  end
end
