require 'date'

require_relative 'base/globals'
require_relative 'base/shared'

require_relative 'core/backup'

require_relative 'validators/configuration'

begin
  Configuration::validate_directories

  backup = Backup.new
  backup.start_environment
  backup.make_copy
rescue StandardError => e
  Shared::LOGGER.error(e.message)
end

=begin
if(Dir.exists?(config.pathInstall) and Dir.exists?(config.pathCopy))
  begin
    backup = Backup.new(config.pathInstall, config.pathCopy, config.dataBaseFolder)
    backup.initializeDirectory()
    backup.makeCopy()

    puts "Comprimiendo copia"
    puts %x(rar a -r -m5 #{config.pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}.rar #{config.pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")})

    puts "Cargando.."
    puts %x(library/rclone.exe -vv --config="config/rclone.conf" copy --dropbox-chunk-size=145000k --retries=5 #{config.pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}.rar remote:#{config.uploadPath})

    backup.deleteCopyDirectory()
  rescue Exception => e
    puts "Error #{e.message}"
    puts %x(library/reminder.exe #{config.pathInstall} #{config.dataBaseFolder} "No se realizó la copia de seguridad #{e.message}")
  end
else
  puts "Error: directorios configurados no existen"
end
=end