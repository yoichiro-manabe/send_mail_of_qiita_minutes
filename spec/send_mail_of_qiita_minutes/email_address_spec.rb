require 'spec_helper'

describe 'EmailAddress' do
  context 'executeを実行するとき' do

    let(:email_addresses) { 'aaa@hoge.com, bbb@hoge.com, ccc@bbb.com' }

    describe 'setオプションが指定されたとき' do
      let(:options) { {:set => email_addresses }}

      before do
        File.unlink SendMailOfQiitaMinutes::CONFIG_FILE_NAME if File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)
        SendMailOfQiitaMinutes::EmailAddress.new(options: options).execute

        @current_config_hash = get_config_hash_from_file
      end

      it 'config.jsonに email_addresses が設定されること' do
        expect(@current_config_hash['email_addresses']).not_to be_nil
      end

      it 'config.jsonの email_addresses に送信先のメールアドレスが配列で設定されること' do
        expect(@current_config_hash['email_addresses']).to eq(email_addresses.split(',').map(&:strip))
      end
    end

    describe 'displayオプションが指定されたとき' do
      let(:options) { {:display => true} }

      describe '値が設定済のとき' do
        before do
          set_options = {:set => email_addresses}
          SendMailOfQiitaMinutes::EmailAddress.new(options: set_options).execute
          @result = SendMailOfQiitaMinutes::EmailAddress.new(options: options).execute
        end

        it '設定した値が配列で取得できること' do
          expect(@result).to eq(email_addresses.split(',').map(&:strip))
        end
      end

      describe 'ファイルが存在するが値が未設定のとき' do
        before do
          json = JSON.dump({})
          write_json json

          @result = SendMailOfQiitaMinutes::EmailAddress.new(options: options).execute
        end

        it "'Unable get email addresses.Execute email_addresses option `email_addresses -s 'aaa@hoge.com, bbb@hoge.com, ccc@bbb.com'`.'が設定されること'" do
          expect(@result).to eq("'Unable get email addresses.Execute email_addresses option `email_addresses -s 'aaa@hoge.com, bbb@hoge.com, ccc@bbb.com'`.'")
        end
      end

      describe 'ファイルが存在しないとき' do
        before do
          File.unlink SendMailOfQiitaMinutes::CONFIG_FILE_NAME if File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)
          @result = SendMailOfQiitaMinutes::EmailAddress.new(options: options).execute
        end

        it "'Unable get email addresses.Execute email_addresses option `email_addresses -s 'aaa@hoge.com, bbb@hoge.com, ccc@bbb.com'`.'が設定されること'" do
          expect(@result).to eq("'Unable get email addresses.Execute email_addresses option `email_addresses -s 'aaa@hoge.com, bbb@hoge.com, ccc@bbb.com'`.'")
        end
      end
    end

    describe 'deleteオプションが指定されたとき' do
      let(:options) { {:delete => true} }

      describe '値が設定済のとき' do
        before do
          set_options = {:set => email_addresses}
          SendMailOfQiitaMinutes::EmailAddress.new(options: set_options).execute
          SendMailOfQiitaMinutes::EmailAddress.new(options: options).execute
        end

        it '設定ファイルから値が削除されていること' do
          current_config_hash = get_config_hash_from_file
          expect(current_config_hash['email_addresses']).to be_nil
        end
      end

      describe 'ファイルが存在するが値が未設定のとき' do
        before do
          json = JSON.dump({})
          write_json json

          SendMailOfQiitaMinutes::EmailAddress.new(options: options).execute
        end

        it '設定ファイルに値が存在しないこと' do
          current_config_hash = get_config_hash_from_file
          expect(current_config_hash['email_addresses']).to be_nil
        end
      end

      describe '設定ファイルが存在しないとき' do
        before do
          File.unlink SendMailOfQiitaMinutes::CONFIG_FILE_NAME if File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)
          SendMailOfQiitaMinutes::EmailAddress.new(options: options).execute
        end

        it 'ファイルが作成されていないこと' do
          expect(File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)).to eq(false)
        end
      end
    end
  end
end