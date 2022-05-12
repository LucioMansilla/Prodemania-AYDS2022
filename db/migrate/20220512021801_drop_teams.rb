class DropTeams < ActiveRecord::Migration[7.0]
  def change
    drop_table :teams
  end
end
