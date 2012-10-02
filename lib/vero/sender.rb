module Vero
  class Sender
    def self.senders
      @senders = {
        true          => Vero::Senders::Thread,
        false         => Vero::Senders::Base,
        :thread       => Vero::Senders::Thread,
        :delayed_job  => Vero::Senders::DelayedJob,
        :synch        => Vero::Senders::Base,
      }
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