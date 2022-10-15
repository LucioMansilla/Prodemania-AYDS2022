# frozen_string_literal: true

class AddPasswordDigestToPlayers < ActiveRecord::Migration[7.0]
  def change
    rename_column :players, :password, :password_digest
  end
end
