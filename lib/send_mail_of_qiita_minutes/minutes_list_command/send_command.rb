require 'send_mail_of_qiita_minutes/qiita_apis/qiita_api_client'

module SendMailOfQiitaMinutes
  module MinutesListCommand
    class SendCommand
      include SendMailOfQiitaMinutes::QiitaApiClient

      def execute_command(item_no:)
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
            email_addresses: to_addresses,
            from: from_address,
            subject: title_and_body_hash['title'],
            body: title_and_body_hash['rendered_body']
        ).deliver_now
      end

      private

      def get_item_id_by_item_no(item_no:)
        if File.exist?(SendMailOfQiitaMinutes::ENTRY_NUMBER_FILE_NAME)
          json = File.open SendMailOfQiitaMinutes::ENTRY_NUMBER_FILE_NAME do |f|
            f.read
          end

          item_data = JSON.load(json)
          item_data[item_no.to_s]
        else
          nil
        end
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
    end
  end
end
