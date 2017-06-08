require 'date'

require_relative 'controllers/Configuration'
require_relative 'controllers/Backup'
require_relative 'controllers/Upload'
require_relative 'library/ZipFileGenerator'

config = Configuration.new
config.readConfig()

if(Dir.exists?(config.pathInstall) and Dir.exists?(config.pathCopy))
  backup = Backup.new(config.pathInstall, config.pathCopy)

  filesReports = backup.getFiles("reportes")
  filesReportsDOS = backup.getFiles("repodos")
  filesDataBase = backup.getFiles("#{config.dataBaseFolder}\\datos")

  backup.createDirectories()

  backup.copyFilesToBackupDirectory(filesReports, "reportes")
  backup.copyFilesToBackupDirectory(filesReportsDOS, "repodos")
  backup.copyFilesToBackupDirectory(filesDataBase, "#{config.dataBaseFolder}\\datos", "DB")

  if(File.exists?("#{config.pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}.zip"))   # Delete .zip file if exists
    backup.deleteCopyFile()
  end

  zipFileGenerator = ZipFileGenerator.new("#{config.pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}", "#{config.pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}.zip")
  zipFileGenerator.write()

  upload = Upload.new
  upload.uploadCopy(config.pathCopy, config.uploadPath)

  backup.deleteCopyDirectory()
  backup.deleteCopyFile()
else
  puts "Error: directorios configurados no existen"
end
