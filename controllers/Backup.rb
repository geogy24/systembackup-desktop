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
      
      files = getFiles(folder['source_folder'])
      
      if(folder.has_key?('destiny_folder'))
        copyFilesToBackupDirectory(files, folder['source_folder'], folder['destiny_folder'])
      else
        copyFilesToBackupDirectory(files, folder['source_folder'])
      end
    end
  end

  private def getFiles(directory)
    return Dir.entries("#{@pathInstall}\\#{directory}")
  end

  private def copyFilesToBackupDirectory(files, folder, destinyFolder = "")
    if (destinyFolder.empty?)
      destinyFolder = folder
    end
    
    quantityFiles = files.size
    actualFile = 0

    files.each do |file|  # verify each element of array
      for extension in EXTENSIONS # verify if the file extension is in array
        if (file.downcase.include?(extension))  
          puts "Copiando #{file} #{actualFile}/#{quantityFiles}"
          FileUtils.cp("#{@pathInstall}\\#{folder}\\#{file}", "#{@pathCopy}\\#{@@dateTime}\\#{destinyFolder}")
          break # found extension
        end
      end

      actualFile += 1
    end
  end

  def deleteCopyDirectory()
    FileUtils.rm_rf("#{@pathCopy}\\#{@@dateTime}")
  end
end
