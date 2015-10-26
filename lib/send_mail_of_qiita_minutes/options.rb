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

        sub_command_parsers['auth_info'] = set_sub_command_parser(description:'auth_info', options:options)
        sub_command_parsers['email_config'] = set_sub_command_parser(description:'email_config', options:options)
        sub_command_parsers['email_addresses'] = set_sub_command_parser(description:'email_addresses', options:options)
        sub_command_parsers['sender_email_address'] = set_sub_command_parser(description:'sender_email_address', options:options)

        sub_command_parsers['minutes_list'] = OptionParser.new do |opt|
          opt.on('-s VAL', '--send=VAL', 'send minuites for email_address.') { |v| options[:send] = v }
        end

        sub_command_parsers
      end

      def self.set_sub_command_parser(description:, options:)
        OptionParser.new do |opt|
          opt.on('-s VAL', '--set=VAL', "set #{description}.") { |v| options[:set] = v }
          opt.on('-d', '--display', "display#{description}.") { |v| options[:display] = v }
          opt.on('-D', '--delete', "delete #{description}.") { |v| options[:delete] = v }
        end
      end
    end
  end
end

