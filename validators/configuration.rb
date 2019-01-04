# Configuration file
# @date 03/01/2019
# @author github @geogy24
class Configuration
  def self.validate_directories
    raise StandardError, "install directory doesn\'t exists: #{Shared::APP_CONFIG[:production][:path_install]}" unless Dir.exist? (Shared::APP_CONFIG[:production][:path_install])
    raise StandardError, "copy directory doesn\'t exists: #{Shared::APP_CONFIG[:production][:path_copy]}" unless Dir.exist? (Shared::APP_CONFIG[:production][:path_copy])
  end
end
