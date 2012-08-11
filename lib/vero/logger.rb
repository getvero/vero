module Vero
  module Logger
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def log(object, message, context = Vero::App.default_context)
        return unless context.config.logging

        logger  = self.logger(context)
        message = "#{object.class.name}: #{message}"

        if logger
          logger.info(message)
        else
          puts(message)
        end
      end

      def logger(context)
        return unless context.config.logging
        Rails.logger if defined?(Rails) && Rails.logger
      end
    end
  end
end