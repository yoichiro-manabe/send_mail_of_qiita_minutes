require 'optparse'
require 'send_mail_of_qiita_minutes/options'

require 'pp'

module SendMailOfQiitaMinutes
  class Command

    def self.run(argv)
      new(argv).execute
    end

    def initialize(argv)
      @argv = argv
      p argv
    end

    def execute
      options = Options.parse!(@argv)
      sub_command = options.delete(:command)

      instance = case sub_command
                   when 'auth_info'
                     AuthInfo.new(options: options).execute
                   when 'email_config'
                     EmailConfig.new(options: options).execute
                   when 'email_addresses'
                     EmailAddress.new(options: options).execute
                   when 'minutes_list'
                     MinutesList.new(options: options).execute
                   when 'sender_email_address'
                     SenderEmailAddress.new(options: options).execute
                 end

    end
  end
end

