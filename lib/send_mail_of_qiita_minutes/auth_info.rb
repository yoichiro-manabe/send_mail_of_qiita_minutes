require 'json'

module SendMailOfQiitaMinutes
  class AuthInfo

    AUTH_INFO_FILE_NAME = 'auth_info.json'.freeze

    def write_auth_info(access_token:, host:)
      data = [{auth_info: {access_token: access_token, host: host}}]
      json = JSON.dump(data)

      File.unlink AUTH_INFO_FILE_NAME if File.exist?(AUTH_INFO_FILE_NAME)

      File.open AUTH_INFO_FILE_NAME, 'w' do |f|
        f.write json
      end
    end

    def read_auth_info

    end
  end
end
