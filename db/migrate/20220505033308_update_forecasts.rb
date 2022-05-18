class UpdateForecasts < ActiveRecord::Migration[7.0]
  def change
    change_table :forecasts do |t|
      t.rename :name , :result
   end
 end
end
