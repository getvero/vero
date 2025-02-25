# frozen_string_literal: true

require "sidekiq"

class Vero::SidekiqWorker
  include ::Sidekiq::Worker

  def perform(api_class, domain, options)
    Vero::Senders::Base.new.call(api_class, domain, options)
  rescue => e
    Vero::App.log_api_call(api_class, options, e.message)
  end
end
