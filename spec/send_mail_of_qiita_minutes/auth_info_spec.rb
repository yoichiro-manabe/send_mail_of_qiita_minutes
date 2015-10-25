require 'spec_helper'

describe 'AuthInfo' do
  context 'executeを実行するとき' do

    let(:access_token) { 'access_token_value' }
    let(:host) { 'host_value' }

    describe 'setオプションが指定されたとき' do
      let(:options) { {:set => "access_token: #{access_token}, host: #{host}"} }

      before do
        File.unlink SendMailOfQiitaMinutes::CONFIG_FILE_NAME if File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)

        SendMailOfQiitaMinutes::AuthInfo.new(options: options).execute

        @current_config_hash = get_config_hash_from_file
      end

      it 'config.jsonに auth_info が設定されること' do
        expect(@current_config_hash['auth_info']).not_to be_nil
      end

      it 'config.jsonの auth_info に access_token が設定され、対応する値が設定されること' do
        expect(@current_config_hash['auth_info']['access_token']).to eq(access_token)
      end

      it 'config.jsonの auth_info に host が設定され、対応する値が設定されること' do
        expect(@current_config_hash['auth_info']['host']).to eq(host)
      end
    end

    describe 'displayオプションが指定されたとき' do
      let(:options) { {:display => true} }

      describe '値が設定済のとき' do
        before do
          set_options = {:set => "access_token: #{access_token}, host: #{host}"}
          SendMailOfQiitaMinutes::AuthInfo.new(options: set_options).execute
          @result = SendMailOfQiitaMinutes::AuthInfo.new(options: options).execute
        end

        it '設定した値がhashとして取得できること' do
          expect(@result.key?('access_token')).to eq(true)
          expect(@result.key?('host')).to eq(true)
        end
      end

      describe 'ファイルが存在するが値が未設定のとき' do
        before do
          json = JSON.dump({})
          write_json json

          @result = SendMailOfQiitaMinutes::AuthInfo.new(options: options).execute
        end

        it '"Unable get auth info.Set auth info."が設定されること' do
          expect(@result).to eq('Unable get auth info.Set auth info.')
        end
      end

      describe 'ファイルが存在しないとき' do
        before do
          File.unlink SendMailOfQiitaMinutes::CONFIG_FILE_NAME if File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)
          @result = SendMailOfQiitaMinutes::AuthInfo.new(options: options).execute
        end

        it '"Unable get auth info.Set auth info."が設定されること' do
          expect(@result).to eq('Unable get auth info.Set auth info.')
        end
      end
    end

    describe 'deleteオプションが指定されたとき' do
      let(:options) { {:delete => true} }

      describe '値が設定済のとき' do
        before do
          set_options = {:set => "access_token: #{access_token}, host: #{host}"}
          SendMailOfQiitaMinutes::AuthInfo.new(options: set_options).execute
          SendMailOfQiitaMinutes::AuthInfo.new(options: options).execute
        end

        it '設定ファイルから値が削除されていること' do
          current_config_hash = get_config_hash_from_file
          expect(current_config_hash['auth_info']).to be_nil
        end
      end

      describe 'ファイルが存在するが値が未設定のとき' do
        before do
          json = JSON.dump({})
          write_json json

          SendMailOfQiitaMinutes::AuthInfo.new(options: options).execute
        end

        it '設定ファイルに値が存在しないこと' do
          current_config_hash = get_config_hash_from_file
          expect(current_config_hash['auth_info']).to be_nil
        end
      end

      describe '設定ファイルが存在しないとき' do
        before do
          File.unlink SendMailOfQiitaMinutes::CONFIG_FILE_NAME if File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)
          SendMailOfQiitaMinutes::AuthInfo.new(options: options).execute
        end

        it 'ファイルが作成されていないこと' do
          expect(File.exist?(SendMailOfQiitaMinutes::CONFIG_FILE_NAME)).to eq(false)
        end
      end
    end
  end
end