class AddTablePwRecovery < ActiveRecord::Migration[7.0]
  def change
    create_table :pw_recoveries do |t|
      t.string :email
      t.string :token
      t.timestamps 
      t.references :player, foreign_key: true
    end
  end
end
