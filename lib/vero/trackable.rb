module Vero
  module Trackable
    def self.included(base)
      @vero_trackable_map = []
      base.extend(ClassMethods)
    end

    module ClassMethods
      def trackable(*args)
        @vero_trackable_map = case @vero_trackable_map
        when Array then (@vero_trackable_map << args).flatten
        else
          args
        end
      end

      def trackable_map
        @vero_trackable_map
      end

      def reset_trackable_map!
        @vero_trackable_map = nil
      end
    end

    def to_vero
      klass = self.class
      result = klass.trackable_map.inject({}) do |hash, symbol|
        hash[symbol] = self.send(symbol)
        hash
      end

      result[:email] = result.delete(:email_address) if result.has_key?(:email_address)
      result[:_user_type] = self.class.name
      result
    end

    def with_vero_context(context = {})
      context = Vero::Context.new(context)
      context.subject = self
      context
    end

    def track(event_name, event_data = {})
      self.with_vero_context(Vero::App.default_context).track(event_name, event_data)
    end
  end
end