require 'rubygems'
require 'bundler/setup'
require 'vero'
require 'sucker_punch/testing/inline'

Dir[::File.expand_path('../support/**/*.rb',  __FILE__)].each { |f| require f }

RSpec.configure do |config|
end

def stub_env(new_env, &block)
  original_env = Rails.env
  Rails.instance_variable_set("@_env", ActiveSupport::StringInquirer.new(new_env))
  block.call
ensure
  Rails.instance_variable_set("@_env", ActiveSupport::StringInquirer.new(original_env))
end
