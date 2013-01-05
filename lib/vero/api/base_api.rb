require 'json'
require 'delayed_job'
require 'rest-client'

module Vero
  module API
    class BaseAPI
      attr_accessor :domain, :options

      def self.perform(domain, options)
        caller = self.new(domain, options)
        caller.perform
      end

      def initialize(domain, options)
        @domain = domain
        @options = options
        setup_logging
      end

      def perform
        validate!
        request
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
      end

      def request_content_type
        {:content_type => :json, :accept => :json}
      end

      def request_params_as_json
        @options.to_json
      end
    end
  end
end