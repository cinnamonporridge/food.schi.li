class MigrateDayPartitions < ActiveRecord::Migration[7.0]
  def up
    execute create_default_day_partitions_sql
  end

  private

  def create_default_day_partitions_sql
    <<~SQL.squish
      INSERT INTO day_partitions (
          user_id
        , name
        , position
        , created_at
        , updated_at
      )
      SELECT u.id       AS user_id
           , 'DEFAULT'  AS name
           , 0          AS position
           , NOW()      AS created_at
           , NOW()      AS updated_at
        FROM users u
        LEFT OUTER JOIN day_partitions dp ON dp.user_id = u.id
                                         AND dp.position = 0
          ON CONFLICT (user_id, position)
          DO
      UPDATE
         SET updated_at = EXCLUDED.updated_at
    SQL
  end
end
