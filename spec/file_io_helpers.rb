module FileIoHelpers

  def get_config_hash_from_file
    current_data = File.open SendMailOfQiitaMinutes::CONFIG_FILE_NAME do |f|
      f.read
    end
    JSON.load(current_data)
  end

  def write_json(json)
    File.open SendMailOfQiitaMinutes::CONFIG_FILE_NAME, 'w' do |f|
      f.write json
    end
  end
end