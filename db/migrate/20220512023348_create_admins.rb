# frozen_string_literal: true

class CreateAdmins < ActiveRecord::Migration[7.0]
  def change
    create_table :admins do |t|
      t.string :name, :password
      t.string :email, index: { unique: true, name: 'unique_emails' }
      t.timestamps
    end
  end
end
