class CreateMatchDayTable < ActiveRecord::Migration[7.0]
  def change

    create_table :match_days do |t| 
      t.string :description
      t.timestamps
      t.references :tournament
    end
  end
end
