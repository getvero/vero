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
        trackable_attrs, other = self.class.trackable_map.partition { |i| i.is_a?(Symbol) }

        result = trackable_attrs.each_with_object({}) do |attr, hash|
          value = public_send(attr) if respond_to?(attr)
          hash[attr] = value unless value.nil?
        end

        if other.is_a?(Array) && !other.empty?
          other.select! { |i| i.is_a?(Hash) && i.key?(:extras) }

          other.each do |h|
            attr = h[:extras]

            # `extras` methods can be private
            if respond_to?(attr, true)
              value = send(attr)
              result.merge!(value) if value.is_a?(Hash)
            end
          end
        end

        if result.key?(:email_address)
          result[:email] = result.delete(:email_address)
        end

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
