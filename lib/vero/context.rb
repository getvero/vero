module Vero
  class Context
    include Vero::APIContext
    attr_accessor :config, :subject

    def initialize(object = {})
      case object
      when Hash
        #stub
      when Vero::Context
        @config = object.config
        @subject = object.subject
      else
        object = Vero::Config.available_attributes.inject({}) do |hash, symbol|
          hash[symbol] = object.respond_to?(symbol) ? object.send(symbol) : nil
          hash
        end
      end

      if object.is_a?(Hash)
        @config = Vero::Config.new
        self.configure(object)
      end
    end

    def configure(hash = {}, &block)
      if hash.is_a?(Hash) && hash.any?
        @config.update_attributes(hash)
      end

      block.call(@config) if block_given?
    end

    def reset!
      @config.reset!
    end

    def disable_requests!
      @config.disable_requests!
    end

    def configured?
      @config.configured?
    end
  end
end