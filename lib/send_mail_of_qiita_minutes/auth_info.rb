require 'json'

module SendMailOfQiitaMinutes
  class AuthInfo

    TARGET_NAME_AUTH_INFO = 'auth_info'.freeze

    def initialize(options:)
      @options = options
    end

    def execute
      if @options.key?(:set)

        hash = {}
        @options[:set].split(',').each do|item|
          key_value = item.split(':')
          hash[key_value[0].strip] = key_value[1].strip
        end

        write_config(access_token: hash['access_token'], host: hash['host'])

      elsif @options.key?(:display)
        hash = read_config

        if hash.blank?
          p 'Unable get auth info.Set auth info.'
        else
          p hash
        end
      elsif @options.key?(:delete)
        delete_config
      else
        raise ArgumentError
      end
    end

    def self.read_config
      result_hash = nil
      if File.exist?(CONFIG_FILE_NAME)
        data = File.open CONFIG_FILE_NAME do |f|
          f.read
        end

        hash = JSON.load data
        result_hash = hash[TARGET_NAME_AUTH_INFO]
      end

      result_hash
    end

    private

    def write_config(access_token:, host:)
      hash = {TARGET_NAME_AUTH_INFO => {'access_token' => access_token, 'host' => host}}
      SendMailOfQiitaMinutes.write_json_for_append target: TARGET_NAME_AUTH_INFO, data: hash
    end

    def delete_config
      SendMailOfQiitaMinutes.delete_config target:TARGET_NAME_AUTH_INFO
    end
  end
end
