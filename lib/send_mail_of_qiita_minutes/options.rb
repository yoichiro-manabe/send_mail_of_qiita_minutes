require 'optparse'

module SendMailOfQiitaMinutes
  class Command
    module Options
      def self.parse!(argv)
        options = {}

        sub_command_parsers = create_sub_command_parsers(options)
        command_parser = create_command_parser

        # parse args
        begin
          command_parser.order!(argv)
          options[:command] = argv.shift
          sub_command_parsers[options[:command]].parse!(argv)
        rescue OptionParser::MissingArgument, OptionParser::InvalidOption, ArgumentError => e
          abort e.message
        end

        options
      end

      private

      def self.create_command_parser
        command_parser = OptionParser.new do |opt|
          opt.on_head('-v', '--version', 'Show program version') do |v|
            opt.version = SendMailOfQiitaMinutes::VERSION
            puts opt.version
            exit
          end
        end
        command_parser
      end

      def self.create_sub_command_parsers(options)
        sub_command_parsers = Hash.new do |k, v|
          raise ArgumentError, "'#{v}' is not send_mail_of_qiita_minutes sub command."
        end

        sub_command_parsers['auth_info'] = OptionParser.new do |opt|
          opt.on('-s VAL', '--set=VAL', 'set access_token and host.') { |v| options[:set] = v }
          opt.on('-d', '--display', 'display access_token and host.') { |v| options[:display] = v }
          opt.on('-D', '--delete', 'delete access_token and host.') { |v| options[:delete] = v }
        end

        sub_command_parsers['email_config'] = OptionParser.new do |opt|
          opt.on('-s VAL', '--set=VAL', 'set a email config.') { |v| options[:set] = v }
          opt.on('-d', '--display', 'display the email config.') { |v| options[:display] = v }
          opt.on('-D', '--delete', 'delete the email config.') { |v| options[:delete] = v }
        end

        sub_command_parsers['email_addresses'] = OptionParser.new do |opt|
          opt.on('-s VAL', '--set=VAL', 'set a email addresses.') { |v| options[:set] = v }
          opt.on('-d', '--display', 'display all email addresses.') { |v| options[:display] = v }
          opt.on('-D', '--delete', 'delete all email addresses.') { |v| options[:delete] = v }
        end

        sub_command_parsers['minutes_list'] = OptionParser.new do |opt|
          opt.on('-s VAL', '--send=VAL', 'send minuites for email_address.') { |v| options[:send] = v }
        end
        sub_command_parsers
      end
    end
  end
end

