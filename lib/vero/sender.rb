module Vero
  class Sender
    attr_accessor :strategy

    def self.send(api_class, sender_strategy, domain, options)
      sender = Vero::Sender.new(sender_strategy)
      sender.perform(api_class, domain, options)
    rescue => e
      Vero::App.log(self.new(nil), "method: #{api_class.name}, options: #{options.to_json}, error: #{e.message}")
    end

    def initialize(strategy)
      @strategy = strategy
    end

    def perform(api_class, domain, options)
      send(method_for_strategy, api_class, domain, options)
    end

    private
    def method_for_strategy
      if @strategy == :thread || @strategy == true
        :send_thread
      elsif @strategy == :delayed_job
        :send_delayed_job
      else
        :send_synchronous
      end
    end

    def send_synchronous(api_class, domain, options)
      api_class.perform(domain, options)
      Vero::App.log(self, "method: #{api_class.name}, options: #{options.to_json}, response: job performed")
    end

    def send_delayed_job(api_class, domain, options)
      ::Delayed::Job.enqueue api_class.new(domain, options)
      Vero::App.log(self, "method: #{api_class.name}, options: #{options.to_json}, response: delayed job queued")
    rescue => e
      if e.message == "Could not find table 'delayed_jobs'"
        raise "To send ratings asynchronously, you must configure delayed_job. Run `rails generate delayed_job:active_record` then `rake db:migrate`."
      else
        raise e
      end
    end

    def send_thread(api_class, domain, options)
      raise "#{self.class.name} does not support sending in another thread."
    end
  end
end