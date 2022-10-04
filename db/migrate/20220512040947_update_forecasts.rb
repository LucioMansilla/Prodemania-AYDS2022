# frozen_string_literal: true

class UpdateForecasts < ActiveRecord::Migration[7.0]
  def change
    change_table :forecasts do |t|
      t.references :match
    end
  end
end
