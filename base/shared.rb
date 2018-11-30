require 'config-file-loader'
require 'logger'

module Shared
    APP_CONFIG = ConfigFileLoader.load('./config.yml')
    LOGGER = Logger.new('logs/backup.log', 'daily')
end