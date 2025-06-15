class ChangeMeasureEnumToStringOnIngredients < ActiveRecord::Migration[7.0]
  def up
    add_column :ingredients, :measure_string, :string, null: true, default: "unit"
    execute migration_sql

    change_table :ingredients, bulk: true do |t|
      t.change :measure_string, :string, null: false
      t.remove :measure
    end

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
