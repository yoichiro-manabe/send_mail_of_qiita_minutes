require 'spec_helper'

describe 'SenderEmailAddress' do
  context 'executeを実行するとき' do

    let(:email_address) { 'aaa@hoge.com' }

    describe 'setオプションが指定されたとき' do
      let(:options) { {:set => email_address }}

      before do
        File.unlink SendMailOfQiitaMinutes::CONFIG_FILE_NAME if File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)
        SendMailOfQiitaMinutes::SenderEmailAddress.new(options: options).execute

        @current_config_hash = get_config_hash_from_file
      end

      it 'config.jsonに email_address が設定されること' do
        expect(@current_config_hash['sender_email_address']).not_to be_nil
      end

      it 'config.jsonの email_address に送信先のメールアドレスが配列で設定されること' do
        expect(@current_config_hash['sender_email_address']).to eq(email_address)
      end
    end

    describe 'displayオプションが指定されたとき' do
      let(:options) { {:display => true} }

      describe '値が設定済のとき' do
        before do
          set_options = {:set => email_address}
          SendMailOfQiitaMinutes::SenderEmailAddress.new(options: set_options).execute
          @result = SendMailOfQiitaMinutes::SenderEmailAddress.new(options: options).execute
        end

        it '設定した値が配列で取得できること' do
          expect(@result).to eq(email_address)
        end
      end

      describe 'ファイルが存在するが値が未設定のとき' do
        before do
          json = JSON.dump({})
          write_json json

          @result = SendMailOfQiitaMinutes::SenderEmailAddress.new(options: options).execute
        end

        it "Unable get email addresses.Execute sender_email_address option `sender_email_address -s 'aaa@hoge.com'`.'が設定されること" do
          expect(@result).to eq("Unable get email addresses.Execute sender_email_address option `sender_email_address -s 'aaa@hoge.com'`.")
        end
      end

      describe 'ファイルが存在しないとき' do
        before do
          File.unlink SendMailOfQiitaMinutes::CONFIG_FILE_NAME if File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)
          @result = SendMailOfQiitaMinutes::SenderEmailAddress.new(options: options).execute
        end

        it "Unable get email addresses.Execute sender_email_address option `sender_email_address -s 'aaa@hoge.com'`.'が設定されること" do
          expect(@result).to eq("Unable get email addresses.Execute sender_email_address option `sender_email_address -s 'aaa@hoge.com'`.")
        end
      end
    end

    describe 'deleteオプションが指定されたとき' do
      let(:options) { {:delete => true} }

      describe '値が設定済のとき' do
        before do
          set_options = {:set => email_address}
          SendMailOfQiitaMinutes::SenderEmailAddress.new(options: set_options).execute
          SendMailOfQiitaMinutes::SenderEmailAddress.new(options: options).execute
        end

        it '設定ファイルから値が削除されていること' do
          current_config_hash = get_config_hash_from_file
          expect(current_config_hash['sender_email_address']).to be_nil
        end
      end

      describe 'ファイルが存在するが値が未設定のとき' do
        before do
          json = JSON.dump({})
          write_json json

          SendMailOfQiitaMinutes::SenderEmailAddress.new(options: options).execute
        end

        it '設定ファイルに値が存在しないこと' do
          current_config_hash = get_config_hash_from_file
          expect(current_config_hash['sender_email_address']).to be_nil
        end
      end

      describe '設定ファイルが存在しないとき' do
        before do
          File.unlink SendMailOfQiitaMinutes::CONFIG_FILE_NAME if File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)
          SendMailOfQiitaMinutes::SenderEmailAddress.new(options: options).execute
        end

        it 'ファイルが作成されていないこと' do
          expect(File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)).to eq(false)
        end
      end
    end
  end
end