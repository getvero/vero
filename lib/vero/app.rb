module Vero
  class App
    @@config = nil

    def self.init(&block)
      @@config = Config.new

      if block_given?
        block.call(self.config)
        @@config.configured = true
      end
    end

    def self.reset!
      @@config = nil
    end

    def self.config
      @@config
    end

    def self.configured?
      self.config && self.config.configured
    end
  end
end