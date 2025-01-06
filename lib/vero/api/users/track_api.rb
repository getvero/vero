# frozen_string_literal: true

module Vero
  module Api
    module Workers
      module Users
        class TrackAPI < BaseAPI
          def url
            "#{@domain}/api/v2/users/track.json"
          end

          def request
            RestClient.post(url, request_params_as_json, request_content_type)
          end

          def validate!
            if options[:id].to_s.strip.empty? && options[:email].to_s.strip.empty?
              raise ArgumentError, "Missing :id or :email"
            end

            return if options[:data].nil? || options[:data].is_a?(Hash)

            raise ArgumentError, ":data must be either nil or a Hash"
          end
        end
      end
    end
  end
end
