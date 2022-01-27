class AddArchivedAtToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :archived_at, :datetime, null: true
  end
end
