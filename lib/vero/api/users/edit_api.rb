# frozen_string_literal: true

module Vero
  module Api
    module Workers
      module Users
        class EditAPI < BaseAPI
          def api_url
            'users/edit.json'
          end

          def http_method
            :put
          end

          def validate!
            raise ArgumentError, 'Missing :id or :email' if options[:id].to_s.blank? && options[:email].to_s.blank?
            raise ArgumentError, ':changes must be a Hash' unless options[:changes].is_a?(Hash)
          end
        end
      end
    end
  end
end
