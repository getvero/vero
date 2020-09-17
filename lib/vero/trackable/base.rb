# frozen_string_literal: true

module Vero
  module Trackable
    module Base
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
        symbols, other = klass.trackable_map.partition { |i| i.is_a?(Symbol) }

        result = symbols.each_with_object({}) do |symbol, hash|
          t = respond_to?(symbol) ? send(symbol) : nil
          hash[symbol] = t unless t.nil?
        end

        if other.is_a?(Array) && !other.empty?
          other.select! { |i| (i.is_a?(Hash) && i.key?(:extras)) }
          other.each do |h|
            symbol = h[:extras]
            t = respond_to?(symbol, true) ? send(symbol) : nil
            result.merge!(t) if t.is_a?(Hash)
          end
        end

        result[:email] = result.delete(:email_address) if result.key?(:email_address)
        result[:_user_type] = self.class.name
        result
      end

      def with_vero_context(context = {})
        context = Vero::Context.new(context)
        context.subject = self
        context
      end

      def with_default_vero_context
        with_vero_context(Vero::App.default_context)
      end
    end
  end
end
