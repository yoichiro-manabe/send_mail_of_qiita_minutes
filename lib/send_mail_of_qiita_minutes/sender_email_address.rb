require 'json'

module SendMailOfQiitaMinutes
  class SenderEmailAddress
    TARGET_NAME_SENDER_EMAIL_ADDRESS = 'sender_email_address'.freeze

    def initialize(options:)
      @options = options
    end

    def execute
      if @options.key?(:set)
        write_config(sender_email_address: @options[:set])

      elsif @options.key?(:display)
        hash = SenderEmailAddress.read_config

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

    def self.read_config(symbolize_names: false)
      result_hash = nil
      if File.exist?(CONFIG_FILE_NAME)
        data = File.open CONFIG_FILE_NAME do |f|
          f.read
        end

        hash = JSON.parse(data)
        result_hash = hash[TARGET_NAME_SENDER_EMAIL_ADDRESS]
      end

      if symbolize_names
        result_hash.map{|k,v| [k.to_sym, v] }.to_h
      else
        result_hash
      end
    end

    private

    def write_config(sender_email_address:)
      hash = {TARGET_NAME_SENDER_EMAIL_ADDRESS => sender_email_address}
      SendMailOfQiitaMinutes.write_json_for_append target: TARGET_NAME_SENDER_EMAIL_ADDRESS, data: hash
    end

    def delete_config
      SendMailOfQiitaMinutes.delete_config  target:TARGET_NAME_SENDER_EMAIL_ADDRESS
    end
  end
end