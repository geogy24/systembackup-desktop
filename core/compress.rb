# Compress backup files
# @date 03/01/2019
# @author github @geogy24
class Compress
  def self.execute
    LOGS.info('compressing directory')
    LOGS.info %x(`rar a -r -m5 #{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time}#{$compress_type} #{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time}`)
    LOGS.info('compressed')
  end
end
