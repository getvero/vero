# frozen_string_literal: true

module Vero
  module Api
    module Workers
      module Users
        class UnsubscribeAPI < BaseAPI
          def api_url
            'users/unsubscribe.json'
          end

          def http_method
            :post
          end

          def validate!
            raise ArgumentError, 'Missing :id or :email' if options[:id].to_s.blank? && options[:email].to_s.blank?
          end
        end
      end
    end
  end
end
