# frozen_string_literal: true

# Upload backup files
# @date 03/01/2019
# @author github @geogy24
class Rclone
  def self.upload
    LOGS.info('uploading')
    command = 'library/rclone.exe -vv --config="rclone.conf" copy --dropbox-chunk-size=145000k '\
      "--retries=5 #{Shared::APP_CONFIG[:production][:path_copy]}\\#{DATE_TIME}#{COMPRESS_TYPE} "\
      "remote:#{Shared::APP_CONFIG[:production][:upload_path]}"
    # rubocop:disable Style/CommandLiteral
    LOGS.info %x(#{command})
    # rubocop:enable Style/CommandLiteral
    LOGS.info('end upload')
  end
end
