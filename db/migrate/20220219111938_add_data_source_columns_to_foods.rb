class AddDataSourceColumnsToFoods < ActiveRecord::Migration[7.0]
  def change
    change_table :foods, bulk: true do |t|
      t.column :data_source_url, :string, null: true
      t.column :data_source_updated_at, :datetime, null: true
    end
  end
end
