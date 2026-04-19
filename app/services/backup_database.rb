class BackupDatabase
  def call
    execute(pgpassword, pg_dump_command)
  end

  private

  def execute(env_variables, command)
    system(env_variables, command)
  end

  def pg_dump_command
    <<~SH.squish
      pg_dump #{database_username_option} #{database_option} #{database_host_option} #{file_option}
    SH
  end

  def database_username_option
    "--username #{database_username}" if database_username.present?
  end

  def database_option
    "--dbname #{database_name}"
  end

  def database_host_option
    "--host #{database_host}" if database_host.present?
  end

  def file_option
    "--file #{backup_pathname}"
  end

  def database_username
    return @database_username if defined?(@database_username)

    @database_username = database_configuration[:username] # may be empty
  end

  def database_name
    database_configuration.fetch(:database)
  end

  def database_host
    return @database_host if defined?(@database_host)

    @database_host = database_configuration[:host] # may be empty
  end

  def backup_pathname
    @backup_pathname ||= Pathname.new(backup_base_directory).join(file_name)
  end

  def file_name
    "#{Rails.env}.latest.dump"
  end

  def backup_base_directory
    directory = Rails.application.config_for(:settings).fetch(:database_backup_base_directory)

    Pathname.new(directory).tap do |pathname|
      FileUtils.mkdir_p(pathname)
    end
  end

  def database_configuration
    @database_configuration ||= ApplicationRecord.connection_db_config.configuration_hash
  end

  def pgpassword
    return {} unless database_configuration.key?(:password)

    {
      "PGPASSWORD" => database_configuration[:password]
    }
  end
end
