# frozen_string_literal: true

require "sidekiq"

class Vero::SidekiqWorker
  include ::Sidekiq::Worker

  def perform(api_class, domain, options)
    Vero::Senders::Base.new.call(api_class, domain, options)
  rescue => e
    Vero::App.log(self, "method: #{api_class}, options: #{options.to_json}, response: #{e.message}")
  end
end
