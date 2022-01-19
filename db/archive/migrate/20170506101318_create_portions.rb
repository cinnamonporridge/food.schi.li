class CreatePortions < ActiveRecord::Migration[5.1]
  def change
    create_table :portions do |t|
      t.string      :name, null: false
      t.references  :nutrition, null: false, foreign_key: true
      t.integer     :amount, null: false

      t.timestamps
    end
  end
end
