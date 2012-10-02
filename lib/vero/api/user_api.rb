module Vero
  module API
    class UserAPI < BaseAPI
      def url
        "#{@domain}/api/v1/user.json"
      end

      def request
        RestClient.post(url, @options)
      end

      def validate!
        result = true
        result &&= options[:email].to_s.blank? == false
        result &&= (options[:data].nil? || options[:data].is_a?(Hash))

        unless result
          raise ArgumentError.new(:email => options[:email], :data => options[:data])
        end
      end
    end
  end
end