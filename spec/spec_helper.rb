require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

require 'coveralls'
Coveralls.wear!

require 'serch'

Serch.configure do |config|
  config.host = ENV['ELASTICSEARCH_1_PORT_9200_TCP_ADDR']
  config.port = ENV['ELASTICSEARCH_1_PORT_9200_TCP_PORT']
end

Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

RSpec.configure do |config|
end
