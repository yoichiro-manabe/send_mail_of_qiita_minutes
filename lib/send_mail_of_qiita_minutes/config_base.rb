module SendMailOfQiitaMinutes
  module ConfigBase
    def delete_config
      SendMailOfQiitaMinutes.delete_config target:@target_name
    end

    def self.get_config(target_name)
      result_hash = nil
      if File.exist?(CONFIG_FILE_NAME)
        data = File.open CONFIG_FILE_NAME do |f|
          f.read
        end

        hash = JSON.load data
        result_hash = hash[target_name]
      end

      result_hash
    end
  end
end