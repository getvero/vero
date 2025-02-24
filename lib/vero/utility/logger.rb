# frozen_string_literal: true

module Vero::Utility::Logger
  FILTER_STRING = "[FILTERED]"

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def log(object, message)
      return unless Vero::App.default_context.config.logging && !defined?(RSpec)

      prefix = case object
      when String
        object
      else
        object.class.name
      end

      message = "#{prefix}: #{message}"

      if (logger = self.logger)
        logger.info(message)
      else
        puts(message)
      end
    end

    def log_api_call(api_class, options, msg)
      log(api_class, "params: #{sanitize_log_payload(options).to_json}, response: #{msg}")
    end

    def sanitize_log_payload(payload)
      if payload.key?(:tracking_api_key)
        payload.merge(tracking_api_key: FILTER_STRING)
      elsif payload.key?("tracking_api_key")
        payload.merge("tracking_api_key" => FILTER_STRING)
      else
        payload
      end
    end

    def logger
      Rails.logger if defined?(Rails)
    end
  end
end
