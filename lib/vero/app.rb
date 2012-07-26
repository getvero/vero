module Vero
  class App
    @@config = nil

    def self.init(&block)
      @@config = Config.new

      if block_given?
        block.call(self.config)
      end
    end

    def self.reset!
      @@config = nil
    end

    def self.disable_requests!
      @@config.disabled = true
    end

    def self.config
      @@config
    end

    def self.configured?
      self.config && self.config.configured
    end

    def self.log(object, message)
      return unless config.logging

      logger  = self.logger
      message = "#{object.class.name}: #{message}"

      if logger
        logger.info message
      else
        puts message
      end
    end

    def self.logger
      return nil unless config.logging
      if defined?(Rails) && Rails.logger
        Rails.logger
      else
        nil
      end
    end
  end
end