require 'dropbox_api'
require 'certified'
require_relative '../config/Config'

class Upload

    MAX_SIZE_PER_REQUEST = 140000000 # 140 MEGAS

    attr_accessor :pathCopy, :pathUpload, :copyFileName

    def initialize(copyDirectory, uploadDirectory)
        @dropboxClient = DropboxApi::Client.new(Config::DROPBOX_API_TOKEN)
        @pathCopy = copyDirectory
        @pathUpload = uploadDirectory
        @copyFileName = DateTime.now.strftime("%Y_%m_%d")
    end 

    def upload()
        deleteExistingCopy()
        uploadCopy()
        checkIfUploaded()
    end

    private def deleteExistingCopy
        @dropboxClient.delete("/#{@uploadDirectory}/#{@copyFileName}.rar")
    end

    private def uploadCopy
        cursor = nil

        # open file
        open("#{@copyDirectory}\\#{@copyFileName}.rar") do |file|
          puts 'Cargando archivo.'

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
                      "name" => "#{@copyFileName}.rar",
                      "path" => "/#{@uploadDirectory}/#{@copyFileName}.rar",
                      "mode" => "add"
                  }
              )
          )

           puts "Carga de archivo finalizada."
        end
    end

    private def checkIfUploaded
        results = @dropboxClient.search("#{@copyFileName}", "/#{@uploadDirectory}/")
        
        if(results.matches.empty?)
            raise "No se cargó la copia."
        end
    end 
end
