class Configuration
    def self.validate_directories
        raise StandardError, "install directory doesn\'t exists: #{Shared::APP_CONFIG[:production][:path_install]}" unless Dir.exists? (Shared::APP_CONFIG[:production][:path_install])
        raise StandardError, "copy directory doesn\'t exists: #{Shared::APP_CONFIG[:production][:path_copy]}" unless Dir.exists? (Shared::APP_CONFIG[:production][:path_copy])
    end
end