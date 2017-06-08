require 'date'

require 'net/sftp'

class Upload
  def uploadCopy(copyDirectory, uploadDirectory)
    Net::SFTP.start('69.164.198.250', 'root', :password => '20d3s3pt13mbr3') do |sftp|
      sftp.upload!("#{copyDirectory}\\#{DateTime.now.strftime("%Y_%m_%d")}.zip", "#{uploadDirectory}/#{DateTime.now.strftime("%Y_%m_%d")}.zip") do |event, uploader, *args|
        case event
        when :open then
          # args[0] : file metadata
          puts "Inicia la carga del archivo: #{args[0].local} -> #{args[0].remote} (#{args[0].size} bytes}"
        when :put then
          # args[0] : file metadata
          # args[1] : byte offset in remote file
          # args[2] : data being written (as string)
          puts "Escribiendo #{args[2].length} bytes a #{args[0].remote} iniciando en #{args[1]}"
        when :close then
          # args[0] : file metadata
          puts "Terminó con #{args[0].remote}"
        when :mkdir then
          # args[0] : remote path name
          puts "Creando directorio #{args[0]}"
        when :finish then
          puts "Cargado!"
        end
      end
    end
  end
end
