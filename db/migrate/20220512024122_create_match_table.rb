class CreateMatchTable < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t|
      t.string :result 
      t.integer :goals_home
      t.integer :goals_away
      t.datetime :datetime 
      t.string :type
      t.timestamps
      t.references :home, index: true, foreign_key: {to_table: :teams}
      t.references :away, index: true, foreign_key: {to_table: :teams}
      t.references :match_day
    end
  end
end
