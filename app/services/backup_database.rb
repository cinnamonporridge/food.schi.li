class BackupDatabase
  def call
    execute(system_command)
  end

  private

  def execute(_command)
    system(system_command)
  end

  def system_command
    <<~SH.squish
      pg_dump #{username_option} #{database_option} #{file_option}
    SH
  end

  def username_option
    "--username #{username}" if username.present?
  end

  def database_option
    "--dbname #{database_name}"
  end

  def file_option
    "--file #{backup_pathname}"
  end

  def username
    return @username if defined?(@username)

    @username = database_configuration[:username] # may be empty
  end

  def database_name
    database_configuration.fetch(:database)
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
end
