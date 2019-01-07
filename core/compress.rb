# frozen_string_literal: true

# Compress backup files
# @date 03/01/2019
# @author github @geogy24
class Compress
  def self.execute
    LOGS.info('compressing directory')
    command = "rar a -r -m5 #{Shared::APP_CONFIG[:production][:path_copy]}\\"\
      "#{DATE_TIME}#{COMPRESS_TYPE} #{Shared::APP_CONFIG[:production][:path_copy]}\\#{DATE_TIME}"
    LOGS.info %x(#{command})
    LOGS.info('compressed')
  end
end
