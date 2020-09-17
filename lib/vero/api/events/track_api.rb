# frozen_string_literal: true

module Vero
  module Api
    module Workers
      module Events
        class TrackAPI < BaseAPI
          def api_url
            'events/track.json'
          end

          def http_method
            :post
          end

          def validate!
            raise ArgumentError, 'Missing :event_name' if options[:event_name].to_s.blank?
            raise ArgumentError, ':data must be either nil or a Hash' unless options[:data].nil? || options[:data].is_a?(Hash)
          end
        end
      end
    end
  end
end
