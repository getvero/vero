module Vero
  module Api
    module Workers
      module Events
        class TrackAPI < BaseAPI
          def url
            "#{@domain}/api/v2/events/track.json"
          end

          def request
            RestClient.post(self.url, self.request_params_as_json, self.request_content_type)
          end

          def validate!
            raise ArgumentError.new("Missing :event_name") if options[:event_name].to_s.blank?
            raise ArgumentError.new(":data must be either nil or a Hash") unless (options[:data].nil? || options[:data].is_a?(Hash))
          end
        end
      end
    end
  end
end
