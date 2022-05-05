class CreateDates < ActiveRecord::Migration[7.0]
  def change
    create_table :dates do |t| 
      t.string :description
    end
  end
end
