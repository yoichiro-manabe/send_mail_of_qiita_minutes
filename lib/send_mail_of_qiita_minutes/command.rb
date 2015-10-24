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
      pp options

      sub_command = options.delete(:command)

      instance = case sub_command
                   when 'auth_info'
                     AuthInfo.new(options: options).execute
                   when 'email_config'
                     EmailConfig.new(options: options).execute
                   when 'email_addresses'
                     p 'email_addresses'
                   when 'minutes_list'
                     p 'minutes_list'
                 end

    end
  end
end
