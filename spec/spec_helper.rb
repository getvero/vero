# frozen_string_literal: true

require "rubygems"
require "bundler/setup"
require "byebug"
require "rspec"
require "webmock/rspec"
require "sidekiq/testing"

require "vero"

Dir[File.expand_path("support/**/*.rb", __dir__)].sort.each { |f| require f }

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.syntax = [:expect]
  end

  config.raise_errors_for_deprecations!

  WebMock.disable_net_connect!
end

def stub_env(new_env, &block)
  original_env = Rails.env
  Rails.instance_variable_set(:@_env, ActiveSupport::StringInquirer.new(new_env))
  block.call
ensure
  Rails.instance_variable_set(:@_env, ActiveSupport::StringInquirer.new(original_env))
end
