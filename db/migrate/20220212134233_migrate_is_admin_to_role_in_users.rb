class MigrateIsAdminToRoleInUsers < ActiveRecord::Migration[7.0]
  def up
    execute(upgrade_sql)
  end

  def down
    # not intended
  end

  private

  def upgrade_sql
    <<~SQL.squish
      UPDATE users
         SET role = target.new_role
        FROM (SELECT id
                   , email
                   , is_admin
                   , CASE
                       WHEN is_admin = TRUE THEN 'admin'
                                            ELSE 'user'
                     END AS new_role
                FROM users) target
       WHERE users.id = target.id
    SQL
  end
end
