require 'rest-client'

module Vero
  module Jobs
    class RestPostJob < Struct.new(:url, :params)
      def perform
        setup_logging
        RestClient.post(url, params)
      end

      private
      def setup_logging
        return unless Vero::App.logger

        RestClient.log = Object.new.tap do |proxy|
          def proxy.<<(message)
            Vero::App.logger.info message
          end
        end
      end
      
    end
  end
end