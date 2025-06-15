class ChangeMeasureEnumToStringOnMeals < ActiveRecord::Migration[7.0]
  # rubocop:disable Rails/BulkChangeTable
  def up
    add_column :meals, :measure_string, :string, null: true, default: "unit"
    execute migration_sql
    change_column_null :meals, :measure_string, false
    remove_column :meals, :measure
    rename_column :meals, :measure_string, :measure
  end
  # rubocop:enable Rails/BulkChangeTable

  def down
    # not intended
  end

  private

  def migration_sql
    <<~SQL.squish
      UPDATE meals
         SET measure_string = CASE WHEN measure = 1 THEN 'unit' ELSE 'piece' END
    SQL
  end
end
