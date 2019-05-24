module Vero
  module Utility
    module Logger
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def log(object, message)
          return unless logging_enabled?

          message = "#{object.class.name}: #{message}"

          if (logger = self.logger)
            logger.info(message)
          else
            puts(message)
          end
        end

        def logger
          if defined?(Rails)
            Rails.logger
          else
            nil
          end
        end

        def logging_enabled?
          logger && Vero::App.default_context.config.logging && !defined(RSpec)
        end
      end
    end
  end
end