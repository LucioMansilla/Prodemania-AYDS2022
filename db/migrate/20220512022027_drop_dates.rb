class DropDates < ActiveRecord::Migration[7.0]
  def change
    drop_table :dates
  end
end
