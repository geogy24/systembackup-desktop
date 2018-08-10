require 'date'
require 'fileutils'

class Backup
  EXTENSIONS = [".frx", ".frt", ".fpt", ".cdx", ".dbf", ".bak"]

  attr_accessor :pathInstall, :pathCopy, :pathDatabaseFolder

  @@dateTime = DateTime.now.strftime("%Y_%m_%d")

  @@folders = nil

  def initialize(pathInstall, pathCopy, pathDatabaseFolder)
    @pathInstall = pathInstall
    @pathCopy = pathCopy
    @pathDatabaseFolder = pathDatabaseFolder

    @@folders = [ { 'source_folder' => 'reportes' },
                  { 'source_folder' => 'repodos' },
                  { 'source_folder' => "#{@pathDatabaseFolder}\\datos", 'destiny_folder' => 'DB'}]
  end

  def initializeDirectory
    deleteCopyFile()
    createDirectories()
  end

  private def deleteCopyFile()
    if(File.exists?("#{@pathCopy}\\#{@@dateTime}.rar"))   # Delete .rar file if exists
      File.delete("#{@pathCopy}\\#{@@dateTime}.rar")
    end
  end

  private def createDirectories()
    if(!Dir.exists?("#{@pathCopy}\\#{@@dateTime}"))
      Dir.mkdir("#{@pathCopy}\\#{@@dateTime}") # Create a root directory
    end
    
    for folder in @@folders
      destinyFolder = "#{@pathCopy}\\#{@@dateTime}\\#{folder['source_folder']}"

      if(folder.has_key?('destiny_folder'))
        destinyFolder = "#{@pathCopy}\\#{@@dateTime}\\#{folder['destiny_folder']}"
      end

      if(!Dir.exists?(destinyFolder))
        Dir.mkdir(destinyFolder) # Create a reports directory
      end
    end
  end

  def makeCopy
    for folder in @@folders
      if(folder.has_key?('destiny_folder'))
        copyFilesToBackupDirectory(folder['source_folder'], folder['destiny_folder'])
      else
        copyFilesToBackupDirectory(folder['source_folder'])
      end
    end
  end

  private def copyFilesToBackupDirectory(folder, destinyFolder = folder)
    Dir.foreach("#{@pathInstall}\\#{folder}\\") { |file|
      if (EXTENSIONS.include? File.extname(file).downcase)
        puts "Copiando #{file}"
        FileUtils.cp("#{@pathInstall}\\#{folder}\\#{file}", "#{@pathCopy}\\#{@@dateTime}\\#{destinyFolder}")
      end
    }
  end

  def deleteCopyDirectory()
    FileUtils.rm_rf("#{@pathCopy}\\#{@@dateTime}")
  end
end
