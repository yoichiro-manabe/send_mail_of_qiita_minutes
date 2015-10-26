
require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'send_mail_of_qiita_minutes'
require 'pp'
require 'file_io_helpers'

RSpec.configure do |c|
  c.include FileIoHelpers
end