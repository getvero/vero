# frozen_string_literal: true

module Vero
  module Api
    module Workers
      module Users
        class EditTagsAPI < BaseAPI
          def api_url
            'users/tags/edit.json'
          end

          def http_method
            :put
          end

          def validate!
            raise ArgumentError, 'Missing :id or :email' if options[:id].to_s.blank? && options[:email].to_s.blank?
            raise ArgumentError, ':add must an Array if present' unless options[:add].nil? || options[:add].is_a?(Array)
            raise ArgumentError, ':remove must an Array if present' unless options[:remove].nil? || options[:remove].is_a?(Array)
            raise ArgumentError, 'Either :add or :remove must be present' if options[:remove].nil? && options[:add].nil?
          end
        end
      end
    end
  end
end
