# frozen_string_literal: true

module Vero
  module Api
    module Workers
      module Users
        class UnsubscribeAPI < BaseAPI
          def url
            "#{@domain}/api/v2/users/unsubscribe.json"
          end

          def request
            RestClient.post(url, @options)
          end

          def validate!
            return unless options[:id].to_s.strip.empty? && options[:email].to_s.strip.empty?

            raise ArgumentError, "Missing :id or :email"
          end
        end
      end
    end
  end
end
