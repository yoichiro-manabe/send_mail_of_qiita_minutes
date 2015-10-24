require 'json'

module SendMailOfQiitaMinutes
  class EmailConfig

    TARGET_NAME_MAIL_CONFIG = 'email_config'.freeze

    def initialize(options:)
      @options = options
    end

    def execute
      if @options.key?(:set)

        hash = {}
        @options[:set].split(',').each do |item|
          key_value = item.split(':')
          hash[key_value[0].strip] = key_value[1].strip
        end

        write_config(address: hash['address'],
                     port: hash['port'],
                     domain: hash[:domain],
                     user_name: hash[:user_name],
                     password: hash[:password])

      elsif @options.key?(:display)
        hash = read_config

        if hash.blank?
          p 'Unable get email config. Set auth info.'
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

    def write_config(address:, port:, domain:, user_name:, password:)
      hash = {TARGET_NAME_MAIL_CONFIG => {
          'address' => address, 'port' => port, 'domain' => domain, 'user_name' => user_name, 'password' => password
      }}

      SendMailOfQiitaMinutes.write_json_for_append target: TARGET_NAME_MAIL_CONFIG, data: hash
    end

    def read_config
      result_hash = nil
      if File.exist?(CONFIG_FILE_NAME)
        data = File.open CONFIG_FILE_NAME do |f|
          f.read
        end

        hash = JSON.load(data)
        result_hash = hash[TARGET_NAME_MAIL_CONFIG]
      end

      result_hash
    end

    def delete_config
      SendMailOfQiitaMinutes.delete_config  target:TARGET_NAME_MAIL_CONFIG
    end
  end
end