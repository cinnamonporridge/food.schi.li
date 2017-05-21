class CreateIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients do |t|
      t.references :recipe, foreign_key: true
      t.references :portion, foreign_key: true
      t.decimal :quantity     , precision: 10, scale: 3

      t.timestamps
    end
  end
end
