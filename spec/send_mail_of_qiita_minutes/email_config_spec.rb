require 'spec_helper'

describe 'EmailConfig' do
  context 'executeを実行するとき' do

    let(:address) { 'smtp.host.local' }
    let(:port) { '587' }
    let(:domain) { 'your.domain.local' }
    let(:user_name) { 'your_user_name' }
    let(:password) { 'your_password' }
    let(:authentication) { 'plain' }
    let(:enable_starttls_auto) { 'true' }

    describe 'setオプションが指定されたとき' do
      let(:options) { {:set => "address: #{address}, port: #{port}, domain: #{domain}, user_name: #{user_name}, password: #{password}, authentication: #{authentication}, enable_starttls_auto: #{enable_starttls_auto}"} }

      before do
        File.unlink SendMailOfQiitaMinutes::CONFIG_FILE_NAME if File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)

        SendMailOfQiitaMinutes::EmailConfig.new(options: options).execute

        @current_config_hash = get_config_hash_from_file
      end

      it 'config.jsonに email_config が設定されること' do
        expect(@current_config_hash['email_config']).not_to be_nil
      end

      it 'config.jsonの email_config に address が設定され、対応する値が設定されること' do
        expect(@current_config_hash['email_config']['address']).to eq(address)
      end

      it 'config.jsonの email_config に port が設定され、対応する値が設定されること' do
        expect(@current_config_hash['email_config']['port']).to eq(port)
      end

      it 'config.jsonの email_config に domain が設定され、対応する値が設定されること' do
        expect(@current_config_hash['email_config']['domain']).to eq(domain)
      end

      it 'config.jsonの email_config に user_name が設定され、対応する値が設定されること' do
        expect(@current_config_hash['email_config']['user_name']).to eq(user_name)
      end

      it 'config.jsonの email_config に password が設定され、対応する値が設定されること' do
        expect(@current_config_hash['email_config']['password']).to eq(password)
      end

      it 'config.jsonの email_config に authentication が設定され、対応する値が設定されること' do
        expect(@current_config_hash['email_config']['authentication']).to eq(authentication)
      end

      it 'config.jsonの email_config に enable_starttls_auto が設定され、対応する値が設定されること' do
        expect(@current_config_hash['email_config']['enable_starttls_auto']).to eq(enable_starttls_auto)
      end
    end

    describe 'displayオプションが指定されたとき' do
      let(:options) { {:display => true} }

      describe '値が設定済のとき' do
        before do
          set_options = {:set => "address: #{address}, port: #{port}, domain: #{domain}, user_name: #{user_name}, password: #{password}, authentication: #{authentication}, enable_starttls_auto: #{enable_starttls_auto}"}
          SendMailOfQiitaMinutes::EmailConfig.new(options: set_options).execute
          @result = SendMailOfQiitaMinutes::EmailConfig.new(options: options).execute
        end

        it 'config.jsonに email_config が設定されること' do
          expect(@result).not_to be_nil
        end

        it 'config.jsonの email_config に address が設定され、対応する値が設定されること' do
          expect(@result['address']).to eq(address)
        end

        it 'config.jsonの email_config に port が設定され、対応する値が設定されること' do
          expect(@result['port']).to eq(port)
        end

        it 'config.jsonの email_config に domain が設定され、対応する値が設定されること' do
          expect(@result['domain']).to eq(domain)
        end

        it 'config.jsonの email_config に user_name が設定され、対応する値が設定されること' do
          expect(@result['user_name']).to eq(user_name)
        end

        it 'config.jsonの email_config に password が設定され、対応する値が設定されること' do
          expect(@result['password']).to eq(password)
        end

        it 'config.jsonの email_config に authentication が設定され、対応する値が設定されること' do
          expect(@result['authentication']).to eq(authentication)
        end

        it 'config.jsonの email_config に enable_starttls_auto が設定され、対応する値が設定されること' do
          expect(@result['enable_starttls_auto']).to eq(enable_starttls_auto)
        end
      end

      describe 'ファイルが存在するが値が未設定のとき' do
        before do
          json = JSON.dump({})
          write_json json

          @result = SendMailOfQiitaMinutes::EmailConfig.new(options: options).execute
        end

        it "'email_config -s 'address: smtp.host.local, port: 587, domain: your.domain.local, user_name: your_user_name, password: your_password, authentication: plain, enable_starttls_auto: true''が設定されること" do
          expect(@result).to eq("Unable get email config. Execute email_config option `email_config -s 'address: smtp.host.local, port: 587, domain: your.domain.local, user_name: your_user_name, password: your_password, authentication: plain, enable_starttls_auto: true'`.")
        end
      end

      describe 'ファイルが存在しないとき' do
        before do
          File.unlink SendMailOfQiitaMinutes::CONFIG_FILE_NAME if File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)
          @result = SendMailOfQiitaMinutes::EmailConfig.new(options: options).execute
        end

        it "'email_config -s 'address: smtp.host.local, port: 587, domain: your.domain.local, user_name: your_user_name, password: your_password, authentication: plain, enable_starttls_auto: true''が設定されること" do
          expect(@result).to eq("Unable get email config. Execute email_config option `email_config -s 'address: smtp.host.local, port: 587, domain: your.domain.local, user_name: your_user_name, password: your_password, authentication: plain, enable_starttls_auto: true'`.")
        end
      end
    end

    describe 'deleteオプションが指定されたとき' do
      let(:options) { {:delete => true} }

      describe '値が設定済のとき' do
        before do
          set_options = {:set => "address: #{address}, port: #{port}, domain: #{domain}, user_name: #{user_name}, password: #{password}, authentication: #{authentication}, enable_starttls_auto: #{enable_starttls_auto}"}
          SendMailOfQiitaMinutes::EmailConfig.new(options: set_options).execute
          SendMailOfQiitaMinutes::EmailConfig.new(options: options).execute
        end

        it '設定ファイルから値が削除されていること' do
          current_config_hash = get_config_hash_from_file
          expect(current_config_hash['email_config']).to be_nil
        end
      end

      describe 'ファイルが存在するが値が未設定のとき' do
        before do
          json = JSON.dump({})
          write_json json

          SendMailOfQiitaMinutes::EmailConfig.new(options: options).execute
        end

        it '設定ファイルに値が存在しないこと' do
          current_config_hash = get_config_hash_from_file
          expect(current_config_hash['email_config']).to be_nil
        end
      end

      describe '設定ファイルが存在しないとき' do
        before do
          File.unlink SendMailOfQiitaMinutes::CONFIG_FILE_NAME if File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)
          SendMailOfQiitaMinutes::EmailConfig.new(options: options).execute
        end

        it 'ファイルが作成されていないこと' do
          expect(File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)).to eq(false)
        end
      end
    end
  end
end