module Vero
  class SenderHash < ::Hash
    def [](key)
      puts key

      if self.has_key?(key)
        super
      else
        klass_name = key.to_s.split("_").map(&:capitalize).join
        eval("Vero::Senders::#{klass_name}")
      end
    end
  end

  class Sender
    def self.senders
      @senders ||= begin
        t = Vero::SenderHash.new

        t.merge!({
          true          => Vero::Senders::Invalid,
          false         => Vero::Senders::Base,
          :none         => Vero::Senders::Base,
          :thread       => Vero::Senders::Invalid
        })

        if RUBY_VERSION =~ /1\.9\./
          t.merge!(
            true        => Vero::Senders::Thread,
            :thread     => Vero::Senders::Thread
          )
        end
        t
      end
    end

    def self.send(api_class, sender_strategy, domain, options)
      sender_class = self.senders.fetch(sender_strategy) { self.senders[false] }
      (sender_class.new).call(api_class, domain, options)
    rescue => e
      Vero::App.log(self.new, "method: #{api_class.name}, options: #{options.to_json}, error: #{e.message}")
      raise e
    end
  end
end