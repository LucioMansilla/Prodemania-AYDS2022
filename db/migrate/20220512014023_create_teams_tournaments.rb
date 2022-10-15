# frozen_string_literal: true

class CreateTeamsTournaments < ActiveRecord::Migration[7.0]
  def change
    create_table :teams_tournaments do |t|
      t.references :team
      t.references :tournament
      t.timestamps
    end
  end
end
