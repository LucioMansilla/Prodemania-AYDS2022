class DropMatches < ActiveRecord::Migration[7.0]
  def change
    drop_table :matches
  end
end
