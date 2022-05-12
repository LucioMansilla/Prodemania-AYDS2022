class EditMatches < ActiveRecord::Migration[7.0]
  def change
    rename_column :matches, :type, :match_type
  end
end
