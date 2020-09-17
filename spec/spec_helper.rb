require 'rubygems'
require 'bundler/setup'
require 'vero'
require 'json'

Dir[::File.expand_path('../support/**/*.rb',  __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = [:expect]
  end

  config.raise_errors_for_deprecations!
end

def stub_env(new_env, &block)
  original_env = Rails.env
  Rails.instance_variable_set("@_env", ActiveSupport::StringInquirer.new(new_env))
  block.call
ensure
  Rails.instance_variable_set("@_env", ActiveSupport::StringInquirer.new(original_env))
end
