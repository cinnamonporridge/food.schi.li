require "test_helper"

class BackupDatabaseTest < ActiveSupport::TestCase
  test "#call without username" do
    service = BackupDatabase.new

    # override private #execute method to prevent system call
    def service.execute(argument)
      argument
    end

    # override private #database_configuration method to simulate username being present
    def service.database_configuration
      ApplicationRecord.connection_db_config.configuration_hash.dup.without(:username)
    end

    expected_system_command = %r{pg_dump --dbname [^ ]+ --file /tmp/food/test\.latest\.dump}

    assert_match expected_system_command, service.call
  end

  test "#call with username" do
    service = BackupDatabase.new

    # override private #execute method to prevent system call
    def service.execute(argument)
      argument
    end

    # override private #database_configuration method to simulate username being present
    def service.database_configuration
      ApplicationRecord.connection_db_config.configuration_hash.dup.merge(username: "fake_user")
    end

    expected_system_command = %r{pg_dump --username fake_user --dbname [^ ]+ --file /tmp/food/test\.latest\.dump}

    assert_match expected_system_command, service.call
  end
end
