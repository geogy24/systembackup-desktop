# frozen_string_literal: true

require 'date'

require_relative 'base/shared'
require_relative 'base/globals'

require_relative 'core/backup'
require_relative 'core/compress'
require_relative 'core/rclone'
require_relative 'core/dbf'

require_relative 'validators/configuration'

LOGS = Shared::Logs.new

begin
  Configuration.validate_directories

  backup = Backup.new
  backup.start_environment
  backup.make_copy

  Compress.execute

  Rclone.upload

  backup.delete_copy_directory
rescue StandardError => e
  Dbf.write_record
  LOGS.error(e.message)
end
