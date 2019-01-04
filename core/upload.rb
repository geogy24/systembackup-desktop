# Upload backup files
# @date 03/01/2019
# @author github @geogy24
class Upload
  def self.execute
    LOGS.info('uploading')
    LOGS.info %x(`library/rclone.exe -vv --config="rclone.conf" copy --dropbox-chunk-size=145000k --retries=5 #{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time}#{$compress_type} remote:#{Shared::APP_CONFIG[:production][:upload_path]}`)
    LOGS.info('end upload')
  end
end
