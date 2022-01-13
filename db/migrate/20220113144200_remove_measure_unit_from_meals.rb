class RemoveMeasureUnitFromMeals < ActiveRecord::Migration[7.0]
  def up
    remove_column :meals, :measure_unit
  end

  def down
    # not intended
  end
end
