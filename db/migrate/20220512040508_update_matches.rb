class UpdateMatches < ActiveRecord::Migration[7.0]
  def change
    rename_column :matches, :goals_home, :home_goals
    rename_column :matches, :goals_away, :away_goals
  end
end
