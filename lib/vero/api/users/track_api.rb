# frozen_string_literal: true

module Vero
  module Api
    module Workers
      module Users
        class TrackAPI < BaseAPI
          def api_url
            'users/track.json'
          end

          def http_method
            :post
          end

          def validate!
            raise ArgumentError, 'Missing :id or :email' if options[:id].to_s.blank? && options[:email].to_s.blank?
            raise ArgumentError, ':data must be either nil or a Hash' unless options[:data].nil? || options[:data].is_a?(Hash)
          end
        end
      end
    end
  end
end
