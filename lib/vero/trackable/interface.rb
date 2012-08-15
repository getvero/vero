module Vero
  module Trackable
    module Interface
      def track(event_name, event_data = {})
        with_default_vero_context.track(event_name, event_data)
      end
    end
  end
end