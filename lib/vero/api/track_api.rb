module Vero
  module API
    class TrackAPI < BaseAPI
      protected
      def request
        RestClient.post(self.url, @options)
      end

      def url
        "#{@domain}/api/v1/track.json"
      end

      def validate!
        result = true
        result &&= options[:event_name].to_s.blank? == false
        result &&= (options[:data].nil? || options[:data].is_a?(Hash))

        unless result
          raise ArgumentError.new(:event_name => options[:event_name], :data => options[:data])
        end
      end
    end
  end
end