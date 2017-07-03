require 'date'

require_relative 'controllers/Configuration'
require_relative 'controllers/Backup'
require_relative 'controllers/Upload'
require_relative 'library/Log'

config = Configuration.new
config.readConfig()

log = Log.new config.uploadPath

if(Dir.exists?(config.pathInstall) and Dir.exists?(config.pathCopy))
  backup = Backup.new(config.pathInstall, config.pathCopy)

  log.sendLog('Obtener elementos', 'Se obtienen los elementos a copiar')
  filesReports = backup.getFiles("reportes")
  filesReportsDOS = backup.getFiles("repodos")
  filesDataBase = backup.getFiles("#{config.dataBaseFolder}\\datos")

  log.sendLog('Crear directorios', 'Se crean los directorios de copia')
  backup.createDirectories()


  log.sendLog('Copiar elementos', 'Se copia los elementos en los directorios de copia')
  backup.copyFilesToBackupDirectory(filesReports, "reportes")
  backup.copyFilesToBackupDirectory(filesReportsDOS, "repodos")
  backup.copyFilesToBackupDirectory(filesDataBase, "#{config.dataBaseFolder}\\datos", "DB")

  if(File.exists?("#{config.pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}.zip"))   # Delete .zip file if exists
    backup.deleteCopyFile()
  end

  log.sendLog('Comprimir archivos', 'Se comprimen los elementos')
  puts %x(rar a -r #{config.pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}.rar #{config.pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")})

  log.sendLog('Cargar archivo de copia', 'Se carga el archivo de copia generado')
  upload = Upload.new
  upload.uploadCopy(config.pathCopy, config.uploadPath)

  log.sendLog('Eliminar copias locales', 'Se eliminan los directorios locales de copia')
  backup.deleteCopyDirectory()
else
  log.sendLog('Configuracion erronea', 'No existen los directorios configurados')
  puts "Error: directorios configurados no existen"
end
