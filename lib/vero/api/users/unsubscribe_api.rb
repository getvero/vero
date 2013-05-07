module Vero
  module Api
    module Workers
      module Users
        class UnsubscribeAPI < BaseAPI
          def url
            "#{@domain}/api/v2/users/unsubscribe.json"
          end

          def request
            RestClient.post(url, @options)
          end

          def validate!
            raise ArgumentError.new("Missing :id or :email") if options[:id].to_s.blank? && options[:email].to_s.blank?
          end
        end
      end
    end
  end
end
