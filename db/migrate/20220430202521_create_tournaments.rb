class CreateTournaments < ActiveRecord::Migration[7.0]
  def change

    create_table :tournaments do |t|
      t.integer :id_Tournament
      t.string :name 
    end

  end
end
