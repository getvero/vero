module Vero
  module Api
    module Workers
      module Users
        class EditAPI < BaseAPI
          def url
            "#{@domain}/api/v2/users/edit.json"
          end

          def request
            RestClient.put(url, self.request_params_as_json, self.request_content_type)
          end

          def validate!
            raise ArgumentError.new("Missing :id or :email") if options[:id].to_s.blank? && options[:email].to_s.blank?
            raise ArgumentError.new(":changes must be a Hash") unless options[:changes].is_a?(Hash)
          end
        end
      end
    end
  end
end
