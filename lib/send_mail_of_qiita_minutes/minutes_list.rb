require 'send_mail_of_qiita_minutes/mailer'
require 'send_mail_of_qiita_minutes/qiita_apis/qiita_api_client'

module SendMailOfQiitaMinutes
  class MinutesList
    include SendMailOfQiitaMinutes::QiitaApiClient

    TARGET_TAG_NAME = '議事録'.freeze

    def initialize(options:)
      p options
      @options = options
    end

    def execute
      if @options.keys.count == 0
        item_hash = get_munites_list
        item_hash.each do |num, item|
          p "#{num} : #{item['title']}"
        end

        save_title_num(item_hash: item_hash)
      end

      if @options.key?(:send)
        item_no = @options[:send].to_i
        SendMailOfQiitaMinutes::MinutesListCommand::SendCommand.new.execute_command(item_no: item_no)
      end
    end

    private

    def get_munites_list
      client = get_qiita_client
      response = client.list_tag_items(TARGET_TAG_NAME)

      item_hash = {}

      unless response.status == 200
        p "response.status is not 200. [status:#{response.status}]"
        p "error raised. See error message and type.[ message:#{response.body['message']} / tyepe:#{response.body['type']}]"
        return item_hash
      end

      response.body.each_with_index do |item, index|
        if item['updated_at'] < (Time.now - 1.weeks)
          next
        end
        item_hash[index] = item
      end

      item_hash
    end

    def save_title_num(item_hash:)
      # save item_num and item_id to json
      save_hash = {}
      item_hash.each do |num, item|
        save_hash[num] = item['id']
      end

      json = JSON.dump(save_hash)

      File.unlink ENTRY_NUMBER_FILE_NAME if File.exist?(ENTRY_NUMBER_FILE_NAME)
      File.open ENTRY_NUMBER_FILE_NAME, 'w' do |f|
        f.write json
      end
    end
  end
end