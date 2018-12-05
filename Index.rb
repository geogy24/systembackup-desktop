require 'date'

require_relative 'base/shared'
require_relative 'base/globals'

require_relative 'core/backup'
require_relative 'core/compress'
require_relative 'core/upload'

require_relative 'validators/configuration'

$logs = Shared::Logs.new

begin
  Configuration::validate_directories

  backup = Backup.new
  backup.start_environment
  backup.make_copy

  Compress.execute
  Upload.execute

  backup.delete_copy_directory
rescue StandardError => e
  $logs.error(e.message)
ensure
  $logs.close
end