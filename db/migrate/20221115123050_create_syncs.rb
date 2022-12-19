# frozen_string_literal: true

class CreateSyncs < ActiveRecord::Migration[7.0]
  def change
    create_table :syncs do |t|
      t.references :supervisor, foreign_key: { to_table: 'users' }

      t.timestamps
    end
  end
end
