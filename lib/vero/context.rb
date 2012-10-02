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
      validate_configured!
      
      identity = subject.to_vero
      options = @config.request_params
      options.merge!(:data => event_data, :event_name => event_name, :identity => identity)

      unless @config.disabled
        Vero::Sender.send Vero::API::Events::TrackAPI, @config.async, @config.domain, options
      end
    end

    def identify!
      validate_configured!
      
      data = subject.to_vero
      options = @config.request_params
      options.merge!(:email => data[:email], :data => data)

      unless @config.disabled
        Vero::Sender.send Vero::API::Users::TrackAPI, @config.async, @config.domain, options
      end
    end

    def update_user!(email = nil)
      validate_configured!
      
      changes = subject.to_vero
      options = @config.request_params
      options.merge!(:email => (email || changes[:email]), :changes => changes)

      unless @config.disabled
        Vero::Sender.send Vero::API::Users::EditAPI, @config.async, @config.domain, options
      end
    end

    def unsubscribe!
      validate_configured!
      
      identity = subject.to_vero
      options = @config.request_params
      options.merge!(:email => identity[:email])

      unless @config.disabled
        Vero::Sender.send Vero::API::Users::UnsubscribeAPI, @config.async, @config.domain, options
      end
    end

    private
    def validate_configured!
      unless @config.configured?
        raise "You must configure the 'vero' gem. Visit https://github.com/semblancesystems/vero for more details."
      end
    end
  end
end