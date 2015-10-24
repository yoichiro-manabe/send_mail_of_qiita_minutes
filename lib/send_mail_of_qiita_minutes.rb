require 'send_mail_of_qiita_minutes/version'
require 'send_mail_of_qiita_minutes/command'
require 'send_mail_of_qiita_minutes/options'
require 'send_mail_of_qiita_minutes/auth_info'
require 'send_mail_of_qiita_minutes/email_config'
require 'send_mail_of_qiita_minutes/email_address'
require 'send_mail_of_qiita_minutes/minutes_list'

require 'active_support/all'
require 'qiita'
require 'pp'

module SendMailOfQiitaMinutes
  CONFIG_FILE_NAME = 'config.json'.freeze

  private
  def self.write_json(data:)

    json = JSON.dump(data)

    File.unlink CONFIG_FILE_NAME if File.exist?(CONFIG_FILE_NAME)
    File.open CONFIG_FILE_NAME, 'w' do |f|
      f.write json
    end
  end

  def self.write_json_for_append(target:, data:)

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
