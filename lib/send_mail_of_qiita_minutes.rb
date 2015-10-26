require 'send_mail_of_qiita_minutes/version'
require 'send_mail_of_qiita_minutes/command'
require 'send_mail_of_qiita_minutes/options'
require 'send_mail_of_qiita_minutes/auth_info'
require 'send_mail_of_qiita_minutes/email_config'
require 'send_mail_of_qiita_minutes/email_address'
require 'send_mail_of_qiita_minutes/sender_email_address'
require 'send_mail_of_qiita_minutes/minutes_list'
require 'send_mail_of_qiita_minutes/config_base'
require 'send_mail_of_qiita_minutes/minutes_list_command/send_command'
require 'send_mail_of_qiita_minutes/qiita_apis/qiita_api_client'

require 'active_support/all'
require 'qiita'
require 'pp'

module SendMailOfQiitaMinutes
  HOME_DIR_NAME = ENV['HOME'] + '/.send_mail_of_qiita_minutes'
  CONFIG_FILE_NAME = HOME_DIR_NAME + '/config.json'.freeze
  ENTRY_NUMBER_FILE_NAME = HOME_DIR_NAME + '/entry_number.json'.freeze

  private
  def self.write_json(data:)

    json = JSON.dump(data)

    Dir.mkdir(HOME_DIR_NAME) unless Dir.exist?(HOME_DIR_NAME)
    File.unlink CONFIG_FILE_NAME if File.exist?(CONFIG_FILE_NAME)
    File.open CONFIG_FILE_NAME, 'w' do |f|
      f.write json
    end
  end

  def self.write_json_for_append(target:, data:)

    Dir.mkdir(HOME_DIR_NAME) unless Dir.exist?(HOME_DIR_NAME)

    current_config_hash = {}
    if File.exist?(CONFIG_FILE_NAME)
      current_data = File.open CONFIG_FILE_NAME do |f|
        f.read
      end

      current_config_hash = JSON.load(current_data)
    end

    current_config_hash.delete(target.to_s) if current_config_hash.key? target.to_s
    current_config_hash[target.to_s] = data[target.to_s]
    json = JSON.dump(current_config_hash)

    File.open CONFIG_FILE_NAME, 'w' do |f|
      f.write json
    end
  end

  def self.delete_config(target:)
    if File.exist?(CONFIG_FILE_NAME)
      current_data = File.open CONFIG_FILE_NAME do |f|
        f.read
      end

      hash = JSON.load(current_data)
      hash.delete(target) if hash.key? target
      write_json data: hash
    end
  end
end
