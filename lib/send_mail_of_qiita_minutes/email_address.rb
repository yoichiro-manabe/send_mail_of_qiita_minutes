require 'send_mail_of_qiita_minutes/config_base'

module SendMailOfQiitaMinutes
  class EmailAddress
    include SendMailOfQiitaMinutes::ConfigBase

    TARGET_NAME_EMAIL_ADDRESSES = 'email_addresses'.freeze

    def initialize(options:)
      @options = options
      @target_name = TARGET_NAME_EMAIL_ADDRESSES
    end

    def execute
      if @options.key?(:set)

        email_addresses = []
        @options[:set].split(',').each do|email_address|
          email_addresses << email_address.strip
        end

        write_config(email_address: email_addresses)

        p 'メールの宛先が保存されました。'

      elsif @options.key?(:display)
        hash = EmailAddress.read_config

        if hash.blank?
          p "'Unable get email addresses.Execute email_addresses option `email_addresses -s 'aaa@hoge.com, bbb@hoge.com, ccc@bbb.com'`.'"
        else
          p hash
        end
      elsif @options.key?(:delete)
        delete_config

        p 'メールの宛先が削除されました。'
      else
        raise ArgumentError
      end
    end

    def self.read_config
      ConfigBase.get_config(TARGET_NAME_EMAIL_ADDRESSES)
    end

    private

    def write_config(email_address:)
      hash = {TARGET_NAME_EMAIL_ADDRESSES => email_address}
      SendMailOfQiitaMinutes.write_json_for_append target: TARGET_NAME_EMAIL_ADDRESSES, data: hash
    end

  end
end