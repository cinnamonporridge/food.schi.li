class CreateNutritions < ActiveRecord::Migration[5.1]
  def change
    create_table :nutritions do |t|
      t.string :name, null: false
      t.integer :unit, null: false, default: "gram"
      t.integer :kcal, null: false, default: 0
      t.decimal :carbs, null: false, default: 0.0, precision: 10, scale: 3
      t.decimal :carbs_sugar_part, null: false, default: 0.0, precision: 10, scale: 3
      t.decimal :protein, null: false, default: 0.0, precision: 10, scale: 3
      t.decimal :fat, null: false, default: 0.0, precision: 10, scale: 3
      t.decimal :fat_saturated, null: false, default: 0.0, precision: 10, scale: 3
      t.decimal :fiber, null: false, default: 0.0, precision: 10, scale: 3

      t.timestamps
    end
  end
end
