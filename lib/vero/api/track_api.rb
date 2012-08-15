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
        result &&= options[:event_name].kind_of?(String) && !options[:event_name].blank?
        result &&= options[:data].nil? || options[:data].kind_of?(Hash)

        raise ArgumentError.new({:event_name => options[:event_name], :data => options[:data]}) unless result
      end
    end
  end
end