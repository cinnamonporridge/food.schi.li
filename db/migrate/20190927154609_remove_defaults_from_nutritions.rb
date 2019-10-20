class RemoveDefaultsFromNutritions < ActiveRecord::Migration[6.0]
  def up
    change_table :nutritions, bulk: true do |t|
      t.change :kcal, :integer, null: false, default: nil
      t.change :carbs, :decimal, precision: 10, scale: 3, null: false, default: nil
      t.change :carbs_sugar_part, :decimal, precision: 10, scale: 3, null: false, default: nil
      t.change :protein, :decimal, precision: 10, scale: 3, null: false, default: nil
      t.change :fat, :decimal, precision: 10, scale: 3, null: false, default: nil
      t.change :fat_saturated, :decimal, precision: 10, scale: 3, null: false, default: nil
      t.change :fiber, :decimal, precision: 10, scale: 3, null: false, default: nil
    end
  end

  def down
    change_table :nutritions, bulk: true do |t|
      t.change :kcal, :integer, default: 0, null: false
      t.change :carbs, :decimal, precision: 10, scale: 3, default: '0.0', null: false
      t.change :carbs_sugar_part, :decimal, precision: 10, scale: 3, default: '0.0', null: false
      t.change :protein, :decimal, precision: 10, scale: 3, default: '0.0', null: false
      t.change :fat, :decimal, precision: 10, scale: 3, default: '0.0', null: false
      t.change :fat_saturated, :decimal, precision: 10, scale: 3, default: '0.0', null: false
      t.change :fiber, :decimal, precision: 10, scale: 3, default: '0.0', null: false
    end
  end
end
