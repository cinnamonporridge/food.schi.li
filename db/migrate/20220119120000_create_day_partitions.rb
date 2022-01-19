class CreateDayPartitions < ActiveRecord::Migration[7.0]
  def change
    create_table :day_partitions do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :name, null: false
      t.bigint :position, null: false

      t.index [:user_id, :name], unique: true
      t.index [:user_id, :position], unique: true

      t.timestamps
    end
  end
end
