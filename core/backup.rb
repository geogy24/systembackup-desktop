require 'date'
require 'fileutils'

class Backup
  def start_environment
    delete_copy_file()
    create_directories()
  end

  private def delete_copy_file
    if(File.exists?("#{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time}#{$compress_type}"))   # Delete compress file if exists
      $logs.info("delete file with same date: #{$date_time}#{$compress_type}")
      File.delete("#{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time}#{$compress_type}")
    end
  end

  private def create_directories
    if(!Dir.exists?("#{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time}"))
      $logs.info("create root directory: #{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time}")
      Dir.mkdir("#{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time}")
    end
    
    for folder in Shared::APP_CONFIG[:production][:folders]
      destiny_folder = "#{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time}\\#{folder['source_folder']}"

      if(folder.has_key?('destiny_folder'))
        destiny_folder = "#{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time}\\#{folder['destiny_folder']}"
      end

      if(!Dir.exists?(destiny_folder))
        $logs.info("create additional directories: #{destiny_folder}")
        Dir.mkdir(destiny_folder) # Create a reports directory
      end
    end
  end

  def make_copy
    for folder in Shared::APP_CONFIG[:production][:folders]
      $logs.info("copy folder: #{folder['source_folder']}")
      if(folder.has_key?('destiny_folder'))
        copy_files_to_backup_directory(folder['source_folder'], folder['destiny_folder'])
      else
        copy_files_to_backup_directory(folder['source_folder'])
      end
    end
  end

  private def copy_files_to_backup_directory(folder, destiny_folder = folder)
    Dir.foreach("#{Shared::APP_CONFIG[:production][:path_install]}\\#{folder}\\") { |file|
      if (Shared::APP_CONFIG[:production][:extensions].include? File.extname(file).downcase)
        $logs.info("copying: #{file}")
        FileUtils.cp("#{Shared::APP_CONFIG[:production][:path_install]}\\#{folder}\\#{file}", "#{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time}\\#{destiny_folder}")
      end
    }
  end

  def delete_copy_directory()
    FileUtils.rm_rf("#{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time}")
  end
end
