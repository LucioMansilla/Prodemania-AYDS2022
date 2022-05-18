class DropForecast < ActiveRecord::Migration[7.0]
  def change
    drop_table :forecasts 
  end
end
