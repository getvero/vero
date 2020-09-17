module Vero
  module Api
    module Workers
      module Users
        class DeleteAPI < BaseAPI
          def url
            "#{@domain}/api/v2/users/delete.json"
          end

          def request
            RestClient.post(url, @options)
          end

          def validate!
            raise ArgumentError.new("Missing :id") if options[:id].to_s.blank?
          end
        end
      end
    end
  end
end
