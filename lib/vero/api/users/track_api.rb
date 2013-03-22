module Vero
  module Api
    module Workers
      module Users
        class TrackAPI < BaseAPI
          def url
            "#{@domain}/api/v2/users/track.json"
          end

          def request
            RestClient.post(url, self.request_params_as_json, self.request_content_type)
          end

          def validate!
            raise ArgumentError.new("Missing :email") if options[:email].to_s.blank?
            raise ArgumentError.new(":data must be either nil or a Hash") unless (options[:data].nil? || options[:data].is_a?(Hash))
          end
        end
      end
    end
  end
end
