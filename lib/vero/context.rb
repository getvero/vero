module Vero
  class Context
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
      @config.disabled = true
    end

    def configured?
      @config.configured?
    end

    ### API methods

    def track!(event_name, event_data)
      options = {:data => event_data, :event_name => event_name, :identity => subject.to_vero}
      
      Vero::Api::Events.track!(options, self)
    end

    def identify!
      data    = subject.to_vero
      options = {:email => data[:email], :data => data}

      Vero::Api::Users.track!(options, self)
    end

    def update_user!(email = nil)
      changes = subject.to_vero
      options = {:email => (email || changes[:email]), :changes => changes}

      Vero::Api::Users.edit_user!(options, self)
    end

    def update_user_tags!(add = [], remove = [])
      identity  = subject.to_vero
      options   = {:email => identity[:email], :add => add, :remove => remove}
      
      Vero::Api::Users.edit_user_tags!(options, self)
    end    

    def unsubscribe!
      identity  = subject.to_vero
      options   = {:email => identity[:email]}

      Vero::Api::Users.unsubscribe!(options, self)
    end
  end
end