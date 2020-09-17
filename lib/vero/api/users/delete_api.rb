# frozen_string_literal: true

module Vero
  module Api
    module Workers
      module Users
        class DeleteAPI < BaseAPI
          def api_url
            'users/delete.json'
          end

          def http_method
            :post
          end

          def validate!
            raise ArgumentError, 'Missing :id' if options[:id].to_s.blank?
          end
        end
      end
    end
  end
end
