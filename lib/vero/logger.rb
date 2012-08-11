module Vero
  module Logger
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def log(object, message)
        return unless Vero::App.default_context.config.logging

        message = "#{object.class.name}: #{message}"

        if (logger = self.logger)
          logger.info(message)
        else
          puts(message)
        end
      end

      def logger
        defined?(Rails) && Rails.logger ? Rails.logger : nil
      end
    end
  end
end