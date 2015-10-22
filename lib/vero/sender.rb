require 'json'

module Vero
  class SenderHash < ::Hash
    def [](key)
      if self.has_key?(key)
        super
      else
        klass_name = key.to_s.split("_").map(&:capitalize).join
        Vero::Senders.const_get(klass_name)
      end
    end
  end

  class Sender
    def self.senders
      t = Vero::SenderHash.new

      t.merge!({
        true          => Vero::Senders::Invalid,
        false         => Vero::Senders::Base,
        :none         => Vero::Senders::Base,
        :thread       => Vero::Senders::Invalid
      })

      if RUBY_VERSION !~ /1\.8\./
        t.merge!(
          true        => Vero::Senders::Thread,
          :thread     => Vero::Senders::Thread
        )
      end

      t
    end

    def self.send(api_class, sender_strategy, domain, options, config)
      sender_class = if self.senders[sender_strategy]
        self.senders[sender_strategy]
      else
        self.senders[false]
      end

      (sender_class.new).call(api_class, domain, options, config)
    rescue => e
      options_s = JSON.dump(options)
      Vero::App.log(self.new, "method: #{api_class.name}, options: #{options_s}, error: #{e.message}")
      raise e
    end
  end
end
