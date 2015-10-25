
module SendMailOfQiitaMinutes
  module QiitaApiClient

    def get_auth_info
      AuthInfo.read_config
    end

    def get_qiita_client
      auto_info = get_auth_info
      client = Qiita::Client.new(host: auto_info['host'], access_token: auto_info['access_token'])
      client
    end

  end
end