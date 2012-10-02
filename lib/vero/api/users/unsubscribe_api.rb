module Vero
  module API
    module Users
      class UnsubscribeAPI < BaseAPI
        def url
          "#{@domain}/api/v2/users/unsubscribe.json"
        end

        def request
          RestClient.post(url, @options)
        end

        def validate!
          result = true
          result &&= options[:email].to_s.blank? == false

          unless result
            raise ArgumentError.new(:email => options[:email])
          end
        end
      end
    end
  end
end