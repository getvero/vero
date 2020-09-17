# frozen_string_literal: true

module Vero
  module Trackable
    module Interface
      def track(event_name, event_data = {}, extras = {})
        track!(event_name, event_data, extras)
      end

      def track!(event_name, event_data = {}, extras = {})
        with_default_vero_context.track!(event_name, event_data, extras)
      end

      def identify!
        with_default_vero_context.identify!
      end
    end
  end
end
