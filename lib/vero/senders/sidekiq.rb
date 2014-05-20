require 'json'
require 'sidekiq'

module Vero
  class SidekiqWorker
    include ::Sidekiq::Worker

    def perform(api_class, domain, options)
      api_class.new(domain, options).perform
      Vero::App.log(self, "method: #{api_class.name}, options: #{options.to_json}, response: sidekiq job queued")
    end
  end

  module Senders
    class Sidekiq
      def call(api_class, domain, options)
        response = ::Vero::SidekiqWorker.perform_async(api_class, domain, options)
        Vero::App.log(self, "method: #{api_class.name}, options: #{options.to_json}, response: sidekiq job queued")
        response
      end
    end
  end
end