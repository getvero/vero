# frozen_string_literal: true

require "sidekiq"

class Vero::SidekiqWorker
  include ::Sidekiq::Worker

  def perform(api_class, domain, options)
    api_class.constantize.new(domain, options).perform

    Vero::App.log(self, "method: #{api_class}, options: #{options.to_json}, response: sidekiq job queued")
  end
end
