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
            raise ArgumentError, 'Missing :id or :email' if options[:id].to_s.blank? && options[:email].to_s.blank?
          end
        end
      end
    end
  end
end
