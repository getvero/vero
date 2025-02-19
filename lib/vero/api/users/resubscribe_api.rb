# frozen_string_literal: true

module Vero
  module Api
    module Workers
      module Users
        class ResubscribeAPI < BaseAPI
          def url
            "#{@domain}/api/v2/users/resubscribe.json"
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
