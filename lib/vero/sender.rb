# frozen_string_literal: true

require "json"

module Vero
  class SenderLookup
    def [](key)
      klass_name = key.to_s.split("_").map(&:capitalize).join

      if Vero::Senders.const_defined?(klass_name)
        Vero::Senders.const_get(klass_name)
      else
        Vero::Senders::Base
      end
    end
  end

  class Sender
    def self.senders
      @senders ||= Vero::SenderLookup.new
    end

    def self.send(api_class, sender_strategy, domain, options)
      senders[sender_strategy].new.call(api_class, domain, options)
    rescue => e
      options_s = JSON.dump(options)
      Vero::App.log(new, "method: #{api_class.name}, options: #{options_s}, error: #{e.message}")
      raise e
    end
  end
end
