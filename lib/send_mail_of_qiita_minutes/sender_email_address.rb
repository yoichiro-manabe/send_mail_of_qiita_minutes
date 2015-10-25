require 'json'
require 'send_mail_of_qiita_minutes/config_base'

module SendMailOfQiitaMinutes
  class SenderEmailAddress
    include SendMailOfQiitaMinutes::ConfigBase

    TARGET_NAME_SENDER_EMAIL_ADDRESS = 'sender_email_address'.freeze

    def initialize(options:)
      @options = options
      @target_name = TARGET_NAME_SENDER_EMAIL_ADDRESS
    end

    def execute
      if @options.key?(:set)
        write_config(sender_email_address: @options[:set])

      elsif @options.key?(:display)
        hash = SenderEmailAddress.read_config

        if hash.blank?
          p "Unable get email addresses.Execute sender_email_address option `sender_email_address -s 'aaa@hoge.com'`."
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
      ConfigBase.get_config(TARGET_NAME_SENDER_EMAIL_ADDRESS)
    end

    private

    def write_config(sender_email_address:)
      hash = {TARGET_NAME_SENDER_EMAIL_ADDRESS => sender_email_address}
      SendMailOfQiitaMinutes.write_json_for_append target: TARGET_NAME_SENDER_EMAIL_ADDRESS, data: hash
    end
  end
end