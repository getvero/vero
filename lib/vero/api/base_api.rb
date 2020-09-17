# frozen_string_literal: true

require 'json'
require 'rest-client'

module Vero
  module Api
    module Workers
      class BaseAPI
        DEFAULT_API_TIMEOUT ||= 60
        ALLOWED_HTTP_METHODS ||= %i[post put].freeze

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
          new_options = options_with_symbolized_keys(val)

          if (extra_config = new_options.delete(:_config)) && extra_config.is_a?(Hash)
            @http_timeout = extra_config[:http_timeout]
          end

          @options = new_options
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
          "#{@domain}/api/v2/#{api_url}"
        end

        def http_method
          raise NotImplementedError
        end

        def api_url
          raise NotImplementedError
        end

        def validate!
          raise "#{self.class.name}#validate! should be overridden"
        end

        def request
          do_request(http_method, url, @options)
        end

        def do_request(method, a_url, params)
          raise ArgumentError, ":method must be one of the follow: #{ALLOWED_HTTP_METHODS.join(', ')}" unless ALLOWED_HTTP_METHODS.include?(method)

          if method == :get
            RestClient::Request.execute(
              method: method,
              url: a_url,
              headers: { params: params },
              timeout: http_timeout
            )
          else
            RestClient::Request.execute(
              method: method,
              url: a_url,
              payload: JSON.dump(params),
              headers: request_content_type,
              timeout: http_timeout
            )
          end
        end

        def request_content_type
          { content_type: :json, accept: :json }
        end

        def http_timeout
          @http_timeout || DEFAULT_API_TIMEOUT
        end

        def options_with_symbolized_keys(val)
          val.each_with_object({}) do |(k, v), h|
            h[k.to_sym] = v
          end
        end
      end
    end
  end
end
