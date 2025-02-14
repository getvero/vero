# frozen_string_literal: true

module Vero
  module Api
    module Workers
      module Users
        class ReidentifyAPI < BaseAPI
          def url
            "#{@domain}/api/v2/users/reidentify.json"
          end

          def request
            RestClient.put(url, request_params_as_json, request_content_type)
          end

          def validate!
            raise ArgumentError, "Missing :id" if options[:id].to_s.blank?
            raise ArgumentError, "Missing :new_id" if options[:new_id].to_s.blank?
          end
        end
      end
    end
  end
end
