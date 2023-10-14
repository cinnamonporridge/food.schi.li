class ChangeUnitEnumToStringOnFoods < ActiveRecord::Migration[7.0]
  def up
    add_column :foods, :unit_string, :string, null: true, default: "gram"
    execute migration_sql
    change_column_null :foods, :unit_string, false
    remove_column :foods, :unit
    rename_column :foods, :unit_string, :unit
  end

  def down
    # not intended
  end

  private

  def migration_sql
    <<~SQL.squish
      UPDATE foods
         SET unit_string = CASE WHEN unit = 1 THEN 'gram' ELSE 'mililiter' END
    SQL
  end
end
