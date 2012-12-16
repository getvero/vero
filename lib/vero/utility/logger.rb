module Vero
  module Utility
    module Logger
      def self.included(base)
        base.extend(ClassMethods)
      end

      module ClassMethods
        def log(object, message)
          return unless Vero::App.default_context.config.logging && !defined?(RSpec)

          message = "#{object.class.name}: #{message}"

          if (logger = self.logger)
            logger.info(message)
          else
            puts(message)
          end
        end

        def logger
          return Rails.logger if defined?(Rails) && Rails.logger
        end
      end
    end
  end
end