# frozen_string_literal: true

require "rest-client"

class Vero::Api::Workers::BaseAPI
  attr_accessor :domain
  attr_reader :options

  def self.perform(domain, options)
    new(domain, options).perform
  end

  def initialize(domain, options)
    @domain = domain
    self.options = options
  end

  def perform
    validate!
    request
  end

  def options=(val)
    @options = val.transform_keys(&:to_sym)
  end

  protected

  def url
  end

  def validate!
    raise "#{self.class.name}#validate! should be overridden"
  end

  def request
    http_client.do_request(request_method, url, @options.except(:_config))
  end

  def request_method
    raise NotImplementedError, "#{self.class.name}#request_method should be overridden"
  end

  def http_client
    Vero::HttpClient.new(
      logger: Vero::App.logger,
      http_timeout: @options.dig(:_config, :http_timeout)
    )
  end
end
