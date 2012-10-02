module Vero
  module API
    module Users
      class EditAPI < BaseAPI
        def url
          "#{@domain}/api/v2/users/edit.json"
        end

        def request
          RestClient.put(url, @options)
        end

        def validate!
          result = true
          result &&= options[:email].to_s.blank? == false
          result &&= options[:changes].is_a?(Hash)

          unless result
            raise ArgumentError.new(:email => options[:email], :changes => options[:changes])
          end
        end
      end
    end
  end
end