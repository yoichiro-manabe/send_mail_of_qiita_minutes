require 'send_mail_of_qiita_minutes/mailer'

module SendMailOfQiitaMinutes
  class MinutesList

    TARGET_TAG_NAME = '議事録'.freeze
    ENTRY_NUMBER_FILE_NAME = 'entry_number.json'.freeze

    def initialize(options:)
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
        item_id = get_item_id_by_item_no(item_no: item_no)
        if item_id.nil?
          p "#{item_no} に対応するデータが存在しませんでした。minutes_list を実行して処理内容を確認してください。"
          return
        end

        title_and_body_hash = get_title_and_rendered_body(item_id: item_id)

        # send email
        email_config_hash = SendMailOfQiitaMinutes::EmailConfig.read_config(symbolize_names: true)
        ActionMailer::Base.smtp_settings = email_config_hash

        to_addresses = SendMailOfQiitaMinutes::EmailAddress.read_config
        from_address = SendMailOfQiitaMinutes::SenderEmailAddress.read_config

        SendMailOfQiitaMinutes::Mailer.send_email(
            email_addresses:to_addresses,
            from:from_address,
            subject:title_and_body_hash['title'],
            body:title_and_body_hash['rendered_body']).deliver_now
      end
    end

    private
    def get_auth_info
      AuthInfo.read_config
    end

    def get_qiita_client
      auto_info = get_auth_info
      client = Qiita::Client.new(host: auto_info['host'], access_token: auto_info['access_token'])
      client
    end

    def get_title_and_rendered_body(item_id:)
      client = get_qiita_client
      response = client.get_item(item_id)

      unless response.status == 200
        p "response.status is not 200. [status:#{response.status}]"
        p "error raised. See error message and type.[ message:#{response.body['message']} / tyepe:#{response.body['type']}]"
        return nil
      end

      {'title' => response.body['title'], 'rendered_body' => response.body['rendered_body']}
    end

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

    def get_item_id_by_item_no(item_no:)
      if File.exist?(ENTRY_NUMBER_FILE_NAME)
        json = File.open ENTRY_NUMBER_FILE_NAME do |f|
          f.read
        end

        item_data = JSON.load(json)
        item_data[item_no.to_s]
      else
        nil
      end
    end
  end
end