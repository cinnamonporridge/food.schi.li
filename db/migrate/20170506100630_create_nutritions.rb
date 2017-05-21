class CreateNutritions < ActiveRecord::Migration[5.1]
  def change
    create_table :nutritions do |t|
      t.string :name
      t.integer :kcal
      t.decimal :carbs            , precision: 10, scale: 3
      t.decimal :carbs_sugar_part , precision: 10, scale: 3
      t.decimal :protein          , precision: 10, scale: 3
      t.decimal :fat              , precision: 10, scale: 3
      t.decimal :fat_saturated    , precision: 10, scale: 3
      t.decimal :fiber            , precision: 10, scale: 3

      t.timestamps
    end
  end
end
