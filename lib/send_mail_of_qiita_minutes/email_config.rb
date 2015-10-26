require 'json'
require 'send_mail_of_qiita_minutes/config_base'

module SendMailOfQiitaMinutes
  class EmailConfig
    include SendMailOfQiitaMinutes::ConfigBase

    TARGET_NAME_MAIL_CONFIG = 'email_config'.freeze

    def initialize(options:)
      @options = options
      @target_name = TARGET_NAME_MAIL_CONFIG
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
                     domain: hash['domain'],
                     user_name: hash['user_name'],
                     password: hash['password'],
                     authentication: hash['authentication'],
                     enable_starttls_auto: hash['enable_starttls_auto']
        )

        p 'メールの送信設定が正常に保存されました。'

      elsif @options.key?(:display)
        hash = EmailConfig.read_config

        if hash.blank?
          p "Unable get email config. Execute email_config option `email_config -s 'address: smtp.host.local, port: 587, domain: your.domain.local, user_name: your_user_name, password: your_password, authentication: plain, enable_starttls_auto: true'`."
        else
          p hash
        end
      elsif @options.key?(:delete)
        delete_config
        p 'メールの送信設定が削除されました。'
      else
        raise ArgumentError
      end
    end

    def self.read_config(symbolize_names: false)
      result_hash = ConfigBase.get_config(TARGET_NAME_MAIL_CONFIG)

      if result_hash && symbolize_names
        result_hash.map{|k,v| [k.to_sym, v] }.to_h
      else
        result_hash
      end
    end

    private

    def write_config(address:, port:, domain:, user_name:, password:, authentication:, enable_starttls_auto:)
      hash = {TARGET_NAME_MAIL_CONFIG => {
          'address' => address,
          'port' => port,
          'domain' => domain,
          'user_name' => user_name,
          'password' => password,
          'authentication' => authentication,
          'enable_starttls_auto' => enable_starttls_auto
      }}

      SendMailOfQiitaMinutes.write_json_for_append target: TARGET_NAME_MAIL_CONFIG, data: hash
    end

  end
end