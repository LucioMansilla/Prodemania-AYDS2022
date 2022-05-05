class CreateForecasts < ActiveRecord::Migration[7.0]
  def change
    create_table :forecasts do |t|
      t.string :name
      t.integer :home_goals
      t.integer :away_goals
      t.integer :points
    end
  end
end
