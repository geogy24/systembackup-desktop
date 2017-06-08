require 'date'

class Backup
  EXTENSIONS = [".frx", ".frt", ".fpt", ".cdx", ".dbf", ".bak"]

  attr_accessor :pathInstall, :pathCopy

  def initialize(pathInstall, pathCopy)
    @pathInstall = pathInstall
    @pathCopy = pathCopy
  end

  def getFiles(directory)
    return Dir.entries("#{@pathInstall}\\#{directory}")
  end

  def createDirectories()
    if(!Dir.exists?("#{@pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}"))
      Dir.mkdir("#{@pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}") # Create a root directory
    end

    if(!Dir.exists?("#{@pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}\\reportes"))
      Dir.mkdir("#{@pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}\\reportes") # Create a reports directory
    end

    if(!Dir.exists?("#{@pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}\\repodos"))
      Dir.mkdir("#{@pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}\\repodos")
    end

    if(!Dir.exists?("#{@pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}\\DB"))
      Dir.mkdir("#{@pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}\\DB") # Create a database directory
    end
  end

  def copyFilesToBackupDirectory(files, folder, destinyFolder = "")
    if (destinyFolder.empty?)
      destinyFolder = folder
    end

    files.each do |file|  # verify each element of array
      for extension in EXTENSIONS # verify if the file extension is in array
        if (file.downcase.include?(extension))
          FileUtils.cp("#{@pathInstall}\\#{folder}\\#{file}", "#{@pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}\\#{destinyFolder}")
          break # found extension
        end
      end
    end
  end

  def deleteCopyDirectory()
    FileUtils.rm_rf("#{@pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}")
  end

  def deleteCopyFile()
    File.delete("#{@pathCopy}\\#{DateTime.now.strftime("%Y_%m_%d")}.zip")
  end
end
