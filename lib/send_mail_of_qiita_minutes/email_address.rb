module SendMailOfQiitaMinutes
  class EmailAddress

    TARGET_NAME_EMAIL_ADDRESSES = 'email_addresses'.freeze

    def initialize(options:)
      @options = options
    end

    def execute
      if @options.key?(:set)

        email_addresses = []
        @options[:set].split(',').each do|email_address|
          email_addresses << email_address.strip
        end

        write_config(email_address: email_addresses)

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

    def write_config(email_address:)
      hash = {TARGET_NAME_EMAIL_ADDRESSES => email_address}
      SendMailOfQiitaMinutes.write_json_for_append target: TARGET_NAME_EMAIL_ADDRESSES, data: hash
    end

    def read_config
      result_hash = nil
      if File.exist?(CONFIG_FILE_NAME)
        data = File.open CONFIG_FILE_NAME do |f|
          f.read
        end

        hash = JSON.load data
        result_hash = hash[TARGET_NAME_EMAIL_ADDRESSES]
      end

      result_hash
    end

    def delete_config
      SendMailOfQiitaMinutes.delete_config target:TARGET_NAME_EMAIL_ADDRESSES
    end
  end
end