class CreateForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :forecasts do |t|
      t.string  :result
      t.integer :home_goals
      t.integer :away_goals
      t.integer :points
      t.references :player
      t.references :tournament
      t.timestamps
    end
  end
end