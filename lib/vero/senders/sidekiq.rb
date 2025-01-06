# frozen_string_literal: true

require "json"
require "sidekiq"

module Vero
  class SidekiqWorker
    include ::Sidekiq::Worker

    def perform(api_class, domain, options)
      api_class.constantize.new(domain, options).perform
      Vero::App.log(self, "method: #{api_class}, options: #{options.to_json}, response: sidekiq job queued")
    end
  end

  module Senders
    class Sidekiq
      def call(api_class, domain, options)
        response = ::Vero::SidekiqWorker.perform_async(api_class.to_s, domain, options)
        Vero::App.log(self, "method: #{api_class.name}, options: #{options.to_json}, response: sidekiq job queued")
        response
      end
    end
  end
end
