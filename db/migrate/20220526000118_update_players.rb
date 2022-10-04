# frozen_string_literal: true

class UpdatePlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :is_admin, :boolean
  end
end
