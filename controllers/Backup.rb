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
    if(!Dir.exists?("#{@pathCopy}\\#{DateTime.now.strftime("%d_%m_%Y")}"))
      Dir.mkdir("#{@pathCopy}\\#{DateTime.now.strftime("%d_%m_%Y")}") # Create a root directory
    end

    if(!Dir.exists?("#{@pathCopy}\\#{DateTime.now.strftime("%d_%m_%Y")}\\reportes"))
      Dir.mkdir("#{@pathCopy}\\#{DateTime.now.strftime("%d_%m_%Y")}\\reportes") # Create a reports directory
    end

    if(!Dir.exists?("#{@pathCopy}\\#{DateTime.now.strftime("%d_%m_%Y")}\\repodos"))
      Dir.mkdir("#{@pathCopy}\\#{DateTime.now.strftime("%d_%m_%Y")}\\repodos")
    end

    if(!Dir.exists?("#{@pathCopy}\\#{DateTime.now.strftime("%d_%m_%Y")}\\DB"))
      Dir.mkdir("#{@pathCopy}\\#{DateTime.now.strftime("%d_%m_%Y")}\\DB") # Create a database directory
    end
  end

  def copyFilesToBackupDirectory(files, folder, destinyFolder = "")
    if (destinyFolder.empty?)
      destinyFolder = folder
    end

    files.each do |file|  # verify each element of array
      for extension in EXTENSIONS # verify if the file extension is in array
        if (file.downcase.include?(extension))
          FileUtils.cp("#{@pathInstall}\\#{folder}\\#{file}", "#{@pathCopy}\\#{DateTime.now.strftime("%d_%m_%Y")}\\#{destinyFolder}")
          break # found extension
        end
      end
    end
  end

  def deleteCopyDirectory()
    FileUtils.rm_rf("#{@pathCopy}\\#{DateTime.now.strftime("%d_%m_%Y")}")
  end

  def deleteCopyFile()
    File.delete("#{@pathCopy}\\#{DateTime.now.strftime("%d_%m_%Y")}.zip")
  end
end
