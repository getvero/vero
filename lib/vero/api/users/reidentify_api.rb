module Vero
  module Api
    module Workers
      module Users
        class ReidentifyAPI < BaseAPI
          def url
            "#{@domain}/api/v2/users/reidentify.json"
          end

          def request
            RestClient.put(url, self.request_params_as_json, self.request_content_type)
          end

          def validate!
            raise ArgumentError.new("Missing :id") if options[:id].to_s.blank?
            raise ArgumentError.new("Missing :new_id") if options[:new_id].to_s.blank?
          end
        end
      end
    end
  end
end
