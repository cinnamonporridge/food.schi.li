class CreateRecipes < ActiveRecord::Migration[5.1]
  def change
    create_table :recipes do |t|
      t.string  :name    , null: false
      t.integer :servings, null: false, default: 1
      t.timestamps
    end
  end
end
