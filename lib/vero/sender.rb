# frozen_string_literal: true

module Vero
  class Sender
    def self.senders
      @senders ||= Vero::Sender::Lookup.new
    end

    def self.call(api_class, sender_strategy, domain, options)
      sender = senders[sender_strategy].new
      sender.call(api_class, domain, options)
    rescue => e
      Vero::App.log(new, "method: #{api_class.name}, options: #{JSON.dump(options)}, error: #{e.message}")
      raise e
    end

    class Lookup
      def [](key)
        klass_name = key.to_s.split("_").map(&:capitalize).join

        if Vero::Senders.const_defined?(klass_name)
          Vero::Senders.const_get(klass_name)
        else
          Vero::Senders::Base
        end
      end
    end
  end
end
