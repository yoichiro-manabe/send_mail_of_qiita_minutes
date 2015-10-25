require 'json'
require 'send_mail_of_qiita_minutes/config_base'

module SendMailOfQiitaMinutes
  class AuthInfo
    include SendMailOfQiitaMinutes::ConfigBase

    TARGET_NAME_AUTH_INFO = 'auth_info'.freeze

    def initialize(options:)
      @options = options
      @target_name = TARGET_NAME_AUTH_INFO
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
        hash = AuthInfo.read_config

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
      ConfigBase.get_config(TARGET_NAME_AUTH_INFO)
    end

    private

    def write_config(access_token:, host:)
      hash = {TARGET_NAME_AUTH_INFO => {'access_token' => access_token, 'host' => host}}
      SendMailOfQiitaMinutes.write_json_for_append target: TARGET_NAME_AUTH_INFO, data: hash
    end
  end
end
