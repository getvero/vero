module Vero
  module API
    module Events
      class TrackAPI < BaseAPI
        def url
          "#{@domain}/api/v2/events/track.json"
        end
        
        def request
          RestClient.post(self.url, self.request_params_as_json, self.request_content_type)
        end

        def validate!
          result = true
          result &&= options[:event_name].to_s.blank? == false
          result &&= (options[:data].nil? || options[:data].is_a?(Hash))

          unless result
            hash = {:data => options[:data], :event_name => options[:event_name]}
            raise ArgumentError.new(JSON.dump(hash))
          end
        end
      end
    end
  end
end