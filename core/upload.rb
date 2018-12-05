class Upload
    def self.execute
        $logs.info("uploading")
        $logs.info %x(library/rclone.exe -vv --config="rclone.conf" copy --dropbox-chunk-size=145000k --retries=5 #{Shared::APP_CONFIG[:production][:path_copy]}\\#{$date_time}#{$compress_type} remote:#{Shared::APP_CONFIG[:production][:upload_path]})
        $logs.info("end upload")
    end
end