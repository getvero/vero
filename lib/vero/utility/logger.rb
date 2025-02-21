# frozen_string_literal: true

module Vero::Utility::Logger
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
      Rails.logger if defined?(Rails)
    end
  end
end
