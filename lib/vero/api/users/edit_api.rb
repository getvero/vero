# frozen_string_literal: true

module Vero
  module Api
    module Workers
      module Users
        class EditAPI < BaseAPI
          def url
            "#{@domain}/api/v2/users/edit.json"
          end

          def request
            RestClient.put(url, request_params_as_json, request_content_type)
          end

          def validate!
            raise ArgumentError, "Missing :id or :email" if options[:id].to_s.blank? && options[:email].to_s.blank?
            raise ArgumentError, ":changes must be a Hash" unless options[:changes].is_a?(Hash)
          end
        end
      end
    end
  end
end
