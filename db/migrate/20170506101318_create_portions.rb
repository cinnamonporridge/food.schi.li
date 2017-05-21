class CreatePortions < ActiveRecord::Migration[5.1]
  def change
    create_table :portions do |t|
      t.string :name
      t.references :nutrition   , foreign_key: true
      t.decimal :multiplier     , precision: 10, scale: 3

      t.timestamps
    end
  end
end
