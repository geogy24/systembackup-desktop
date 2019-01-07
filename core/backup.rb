# frozen_string_literal: true

require 'date'
require 'fileutils'

# Backup files
# @date 03/01/2019
# @author github @geogy24
class Backup
  def start_environment
    delete_copy_file
    create_directories
  end

  def make_copy
    Shared::APP_CONFIG[:production][:folders].each do |folder|
      LOGS.info("copy folder: #{folder['source_folder']}")
      if folder.key?('destiny_folder')
        copy_files_to_backup_directory(folder['source_folder'],
                                       folder['destiny_folder'])
      else
        copy_files_to_backup_directory(folder['source_folder'])
      end
    end
  end

  def delete_copy_directory
    FileUtils.rm_rf("#{Shared::APP_CONFIG[:production][:path_copy]}"\
      "\\#{DATE_TIME}")
  end

  private

  def delete_copy_file
    return unless File.exist?("#{Shared::APP_CONFIG[:production][:path_copy]}"\
      "\\#{DATE_TIME}#{COMPRESS_TYPE}")

    LOGS.info("delete file with same date: #{DATE_TIME}#{COMPRESS_TYPE}")
    File.delete("#{Shared::APP_CONFIG[:production][:path_copy]}\\"\
      "#{DATE_TIME}#{COMPRESS_TYPE}")
  end

  def create_directories
    make_root_folder
    make_additional_folders
  end

  def make_root_folder
    return if Dir.exist?("#{Shared::APP_CONFIG[:production][:path_copy]}"\
      "\\#{DATE_TIME}")

    LOGS.info('create root directory: '\
      "#{Shared::APP_CONFIG[:production][:path_copy]}\\#{DATE_TIME}")
    Dir.mkdir("#{Shared::APP_CONFIG[:production][:path_copy]}\\#{DATE_TIME}")
  end

  def make_additional_folders
    Shared::APP_CONFIG[:production][:folders].each do |folder|
      destiny_folder = "#{Shared::APP_CONFIG[:production][:path_copy]}\\#{DATE_TIME}"\
        "\\#{folder.key?('destiny_folder') ? folder['destiny_folder'] : folder['source_folder']}"

      next if Dir.exist?(destiny_folder)

      LOGS.info("create additional directories: #{destiny_folder}")
      Dir.mkdir(destiny_folder) # Create a reports directory
    end
  end

  def copy_files_to_backup_directory(folder, destiny_folder = folder)
    Dir.foreach("#{Shared::APP_CONFIG[:production][:path_install]}\\#{folder}\\") do |file|
      if Shared::APP_CONFIG[:production][:extensions].include? File.extname(file).downcase
        LOGS.info("copying: #{file}")
        FileUtils.cp("#{Shared::APP_CONFIG[:production][:path_install]}\\#{folder}\\#{file}",
                     "#{Shared::APP_CONFIG[:production][:path_copy]}\\#{DATE_TIME}"\
                      "\\#{destiny_folder}")
      end
    end
  end
end
