class AddVeganToRecipe < ActiveRecord::Migration[5.2]
  def change
    add_column :recipes, :vegan, :boolean, default: false, null: false
  end
end
