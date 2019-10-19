# rubocop:disable Rails/BulkChangeTable
class RemoveDefaultsFromNutritions < ActiveRecord::Migration[6.0]
  def up
    change_column :nutritions, :kcal, :integer, null: false, default: nil
    change_column :nutritions, :carbs, :decimal, precision: 10, scale: 3, null: false, default: nil
    change_column :nutritions, :carbs_sugar_part, :decimal, precision: 10, scale: 3, null: false, default: nil
    change_column :nutritions, :protein, :decimal, precision: 10, scale: 3, null: false, default: nil
    change_column :nutritions, :fat, :decimal, precision: 10, scale: 3, null: false, default: nil
    change_column :nutritions, :fat_saturated, :decimal, precision: 10, scale: 3, null: false, default: nil
    change_column :nutritions, :fiber, :decimal, precision: 10, scale: 3, null: false, default: nil
  end

  def down
    change_column :nutritions, :kcal, :integer, default: 0, null: false
    change_column :nutritions, :carbs, :decimal, precision: 10, scale: 3, default: '0.0', null: false
    change_column :nutritions, :carbs_sugar_part, :decimal, precision: 10, scale: 3, default: '0.0', null: false
    change_column :nutritions, :protein, :decimal, precision: 10, scale: 3, default: '0.0', null: false
    change_column :nutritions, :fat, :decimal, precision: 10, scale: 3, default: '0.0', null: false
    change_column :nutritions, :fat_saturated, :decimal, precision: 10, scale: 3, default: '0.0', null: false
    change_column :nutritions, :fiber, :decimal, precision: 10, scale: 3, default: '0.0', null: false
  end
end
# rubocop:enable Rails/BulkChangeTable
