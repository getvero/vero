module Vero
  class Sender
    attr_accessor :strategy

    def self.send(api_class, sender_strategy, domain, options)
      sender = Vero::Sender.new(sender_strategy)
      sender.perform(api_class, domain, options)
    rescue => e
      Vero::App.log(self.new(nil), "method: #{api_class.name}, options: #{options.to_json}, error: #{e.message}")
      raise e
    end

    def initialize(strategy)
      @strategy = strategy
    end

    def perform(api_class, domain, options)
      send(method_for_strategy, api_class, domain, options)
    end

    private
    def method_for_strategy
      case @strategy
      when true         then :send_thread
      when :thread      then :send_thread
      when :delayed_job then :send_delayed_job
      else
        :send_synchronous
      end
    end

    def send_synchronous(api_class, domain, options)
      response = api_class.perform(domain, options)
      Vero::App.log(self, "method: #{api_class.name}, options: #{options.to_json}, response: job performed")

      response
    end

    def send_delayed_job(api_class, domain, options)
      response = ::Delayed::Job.enqueue api_class.new(domain, options)
      Vero::App.log(self, "method: #{api_class.name}, options: #{options.to_json}, response: delayed job queued")

      response
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