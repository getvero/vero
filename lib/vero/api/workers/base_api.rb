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
    setup_logging
  end

  def perform
    validate!
    request
  end

  def options=(val)
    @options = options_with_symbolized_keys(val)
  end

  protected

  def setup_logging
    return unless Vero::App.logger

    RestClient.log = Object.new.tap do |proxy|
      def proxy.<<(message)
        Vero::App.logger.info message
      end
    end
  end

  def url
  end

  def validate!
    raise "#{self.class.name}#validate! should be overridden"
  end

  def request
    request_headers = {content_type: :json, accept: :json}

    if request_method == :get
      RestClient.get(url, request_headers)
    else
      RestClient.send(request_method, url, JSON.dump(@options), request_headers)
    end
  end

  def request_method
    raise NotImplementedError, "#{self.class.name}#request_method should be overridden"
  end

  def options_with_symbolized_keys(val)
    val.transform_keys(&:to_sym)
  end
end
