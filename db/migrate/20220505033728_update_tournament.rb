class UpdateTournament < ActiveRecord::Migration[7.0]
  def change
    change_table :tournaments do |t|
      t.remove :id_Tournament
   end
  end
end
