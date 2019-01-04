require 'config-file-loader'
require 'logger'

module Shared
  APP_CONFIG = ConfigFileLoader.load('./config.yml')

  # logs
  # @date 03/01/2019
  # @author github @geogy24
  class Logs
    def initialize
      @logger_file = Logger.new('logs/backup.log', 'daily')
      @logger_console = Logger.new(STDOUT)
    end

    def info(message)
      @logger_file.info(message)
      @logger_console.info(message)
    end

    def error(message)
      @logger_file.error(message)
      @logger_console.error(message)
    end

    def close
      @logger_file.close
      @logger_console.close
    end
  end
end
