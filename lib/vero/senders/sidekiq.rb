require 'json'
require 'sidekiq'

module Vero
  class SidekiqWorker
    include ::Sidekiq::Worker

    def perform(api_class, domain, options)
      send_to_vero(api_class, domain, options)
    end

    protected

    def send_to_vero(api_class, domain, options)
      api_klass(api_class).new(domain, options).perform
      Vero::App.log(self, "method: #{api_class}, options: #{options.to_json}, response: sidekiq job performed")
    end

    def api_klass(api_class)
      api_class.constantize
    end
  end

  module Senders
    class Sidekiq
      def call(api_class, domain, options)
        response = sender_class.perform_async(api_class.to_s, domain, options)
        Vero::App.log(self, "method: #{api_class.name}, options: #{options.to_json}, response: sidekiq job queued")
        response
      end

      def sender_class
        ::Vero::SidekiqWorker
      end
    end
  end
end
