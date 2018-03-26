require 'json'

class Configuration
  CONFIG_PATH_FILE = 'config/config'

  attr_accessor :pathInstall, :pathCopy, :uploadPath, :dataBaseFolder

  def readConfig
    content = ""

    if (File.exist?(CONFIG_PATH_FILE))
      File.open(CONFIG_PATH_FILE, 'r') { |fileContent|
        content += fileContent.read
      }

      convertStringToJSON(content)
    else
      puts "Error: archivo de configuración no existe"
    end
  end

  private
  def convertStringToJSON(content)
    if(!content.empty?)
      jsonConfig = JSON.parse(content)

      jsonConfig.inspect

      @pathInstall = jsonConfig["path_install"]
      @pathCopy = jsonConfig["path_copy"]
      @uploadPath = jsonConfig["upload_path"]
      @dataBaseFolder = jsonConfig["data_base_folder"]
    else
      puts "Error: no existe configuración"
    end
  end
end