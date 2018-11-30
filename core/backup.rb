require 'date'
require 'fileutils'
require_relative '../base/shared'

class Backup
  include Shared

  EXTENSIONS = [".frx", ".frt", ".fpt", ".cdx", ".dbf", ".bak"]

  attr_accessor :path_install, :path_copy, :path_database_folder

  @@date_time = DateTime.now.strftime("%Y_%m_%d")

  def initialize()
    puts Shared::APP_CONFIG[:production][:extensions]

    #@path_install = path_install
    #@path_copy = path_copy
    #@path_database_folder = path_database_folder

    #@@folders = [ { 'source_folder' => 'reportes' },
    #              { 'source_folder' => 'repodos' },
    #              { 'source_folder' => "#{@path_database_folder}\\datos", 'destiny_folder' => 'DB'}]
  end

  def initializeDirectory
    deleteCopyFile()
    createDirectories()
  end

  private def deleteCopyFile()
    if(File.exists?("#{@path_copy}\\#{@@date_time}.rar"))   # Delete .rar file if exists
      File.delete("#{@path_copy}\\#{@@date_time}.rar")
    end
  end

  private def createDirectories()
    if(!Dir.exists?("#{@path_copy}\\#{@@date_time}"))
      Dir.mkdir("#{@path_copy}\\#{@@date_time}") # Create a root directory
    end
    
    for folder in @@folders
      destinyFolder = "#{@path_copy}\\#{@@date_time}\\#{folder['source_folder']}"

      if(folder.has_key?('destiny_folder'))
        destinyFolder = "#{@path_copy}\\#{@@date_time}\\#{folder['destiny_folder']}"
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
    Dir.foreach("#{@path_install}\\#{folder}\\") { |file|
      if (EXTENSIONS.include? File.extname(file).downcase)
        puts "Copiando #{file}"
        FileUtils.cp("#{@path_install}\\#{folder}\\#{file}", "#{@path_copy}\\#{@@date_time}\\#{destinyFolder}")
      end
    }
  end

  def deleteCopyDirectory()
    FileUtils.rm_rf("#{@path_copy}\\#{@@date_time}")
  end
end
