module Vero
  module Api
    module Workers
      module Users
        class EditTagsAPI < BaseAPI
          def url
            "#{@domain}/api/v2/users/tags/edit.json"
          end

          def request
            RestClient.put(url, self.request_params_as_json, self.request_content_type)
          end

          def validate!
            result = true
            result &&= options[:email].to_s.blank? == false
            result &&= (options[:add].is_a?(Array) || options[:remove].is_a?(Array))

            unless result
              raise ArgumentError.new(:email => options[:email], :add => options[:add], :remove => options[:remove])
            end
          end
        end
      end
    end
  end
end