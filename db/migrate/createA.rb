class CreateAdmins < ActiveRecord::Migration[7.0]
    def change
      create_table :admins do |t|
        t.integer :id_Admin, :primary_key
        add_column :name, :email, :password, :string
        add_index :name, :email, unique: true
      end
  
    end
  end