# frozen_string_literal: true

module Vero
  module Api
    module Workers
      module Users
        class EditTagsAPI < BaseAPI
          def url
            "#{@domain}/api/v2/users/tags/edit.json"
          end

          def request
            RestClient.put(url, request_params_as_json, request_content_type)
          end

          def validate!
            if options[:id].to_s.strip.empty? && options[:email].to_s.strip.empty?
              raise ArgumentError, "Missing :id or :email"
            end

            raise ArgumentError, ":add must an Array if present" unless options[:add].nil? || options[:add].is_a?(Array)

            unless options[:remove].nil? || options[:remove].is_a?(Array)
              raise ArgumentError, ":remove must an Array if present"
            end

            return unless options[:remove].nil? && options[:add].nil?

            raise ArgumentError, "Either :add or :remove must be present"
          end
        end
      end
    end
  end
end
