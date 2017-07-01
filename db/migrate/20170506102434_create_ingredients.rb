class CreateIngredients < ActiveRecord::Migration[5.1]
  def change
    create_table :ingredients do |t|
      t.references :recipe    , null: false, foreign_key: true
      t.references :portion   , null: true
      t.decimal    :amount    , null: false

      t.timestamps
    end
  end
end
