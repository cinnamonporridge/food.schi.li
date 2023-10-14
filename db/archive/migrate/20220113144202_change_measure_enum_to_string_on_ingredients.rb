class ChangeMeasureEnumToStringOnIngredients < ActiveRecord::Migration[7.0]
  def up
    add_column :ingredients, :measure_string, :string, null: true, default: "unit"
    execute migration_sql
    change_column_null :ingredients, :measure_string, false
    remove_column :ingredients, :measure
    rename_column :ingredients, :measure_string, :measure
  end

  def down
    # not intended
  end

  private

  def migration_sql
    <<~SQL.squish
      UPDATE ingredients
         SET measure_string = CASE WHEN measure = 1 THEN 'unit' ELSE 'piece' END
    SQL
  end
end
