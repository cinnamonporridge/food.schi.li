require "test_helper"

class BackupDatabaseTest < ActiveSupport::TestCase
  test "#call without username, password and host" do
    service = BackupDatabase.new

    # override private #execute method to prevent system call
    def service.execute(env_variables, command)
      [env_variables, command]
    end

    # override private #database_configuration method to simulate username being present
    def service.database_configuration
      ApplicationRecord.connection_db_config.configuration_hash.dup.without(:username, :password, :host)
    end

    expected_env_variables = {}
    expected_command = %r{pg_dump --dbname [^ ]+ --file /tmp/food/test\.latest\.dump}

    service.call.tap do |env_variables, command|
      assert_equal expected_env_variables, env_variables
      assert_match expected_command, command
    end
  end

  test "#call with username" do
    service = BackupDatabase.new

    # override private #execute method to prevent system call
    def service.execute(env_variables, command)
      [env_variables, command]
    end

    # override private #database_configuration method to simulate username being present
    def service.database_configuration
      ApplicationRecord.connection_db_config.configuration_hash.dup.merge(username: "fake_user",
                                                                          password: "fake_password",
                                                                          host: "fake-host")
    end

    expected_env_variables = { "PGPASSWORD" => "fake_password" }
    expected_command =
      %r{pg_dump --username fake_user --dbname [^ ]+ --host fake-host --file /tmp/food/test\.latest\.dump}

    service.call.tap do |env_variables, command|
      assert_equal expected_env_variables, env_variables
      assert_match expected_command, command
    end
  end
end
