class CreateMatches < ActiveRecord::Migration[7.0]
  def change
    create_table :matches do |t| 
      t.string :matches
      t.integer :home_goals
      t.integer :away_goals
      t.datetime :datetime
      t.string :type
    end
  end
end
