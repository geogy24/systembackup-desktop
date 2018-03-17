require 'dropbox_api'
require 'certified'
require_relative '../config/Config'

class Upload

    MAX_SIZE_PER_REQUEST = 140000000 # 140 MEGAS

    def initialize()
        @dropboxClient = DropboxApi::Client.new(Config::DROPBOX_API_TOKEN)
    end 

    def uploadCopy(copyDirectory, uploadDirectory)
        #folderObject = @dropboxClient.list_folder('/almapaisa')
        #puts folderObject.inspect()
        cursor = nil

        # open file
        open("#{copyDirectory}\\#{DateTime.now.strftime("%Y_%m_%d")}.rar") do |file|
          puts 'File uploading.'

          while record = file.read(MAX_SIZE_PER_REQUEST)
            puts '.'

            if (cursor == nil)
              cursor = @dropboxClient.upload_session_start(record)
            else
              cursor.upload_session_append_v2(cursor, record)
            end
          end

          @dropboxClient.upload_session_finish(cursor, 
              DropboxApi::Metadata::CommitInfo.new(
                  {
                      "name" => "#{DateTime.now.strftime("%Y_%m_%d")}.rar",
                      "path" => "/#{uploadDirectory}/#{DateTime.now.strftime("%Y_%m_%d")}.rar",
                      "mode" => "add"
                  }
              )
          )

           puts "File upload finish."
        end
    end
end
