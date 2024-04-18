# frozen_string_literal: true

module Vero
  module Api
    module Workers
      module Users
        class ReidentifyAPI < BaseAPI
          def api_url
            'users/reidentify.json'
          end

          def http_method
            :put
          end

          def validate!
            raise ArgumentError, 'Missing :id' if options[:id].to_s.blank?
            raise ArgumentError, 'Missing :new_id' if options[:new_id].to_s.blank?
          end
        end
      end
    end
  end
end
