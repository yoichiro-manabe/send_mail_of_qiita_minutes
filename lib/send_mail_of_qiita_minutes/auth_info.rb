require 'json'

module SendMailOfQiitaMinutes
  class AuthInfo

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

    private

    def write_config(access_token:, host:)

      p "access_token:#{access_token} / host: #{host}"

      hash = {'auth_info' => {'access_token' => access_token, 'host' => host}}
      SendMailOfQiitaMinutes.write_json_for_append target: 'auth_info', data: hash
    end

    def read_config
      result_hash = nil
      if File.exist?(CONFIG_FILE_NAME)
        data = File.open CONFIG_FILE_NAME do |f|
          f.read
        end

        hash = JSON.load data
        result_hash = hash['auth_info']
      end

      result_hash
    end

    def delete_config
      SendMailOfQiitaMinutes.delete_config target:'auth_info'
      # if File.exist?(CONFIG_FILE_NAME)
      #   current_data = File.open CONFIG_FILE_NAME do |f|
      #     f.read
      #   end
      #
      #   hash = JSON.load(current_data)
      #   hash.delete('auth_info') if hash.key? 'auth_info'
      #   SendMailOfQiitaMinutes.write_json data: hash
      # end
    end
  end
end