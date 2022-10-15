# frozen_string_literal: true

class CreatePoints < ActiveRecord::Migration[7.0]
  def change
    create_table :points do |t|
      t.integer :total_points
      t.references :tournament
      t.references :player
      t.timestamps
    end
  end
end
