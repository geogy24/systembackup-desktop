class Compress
    def self.execute
        $logs.info("compressing directory")
        $logs.info %x(rar a -r -m5 #{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time}#{$compress_type} #{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time})
        $logs.info("compressed")
    end
end