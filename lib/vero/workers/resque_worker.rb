# frozen_string_literal: true

require "resque"

class Vero::ResqueWorker
  @queue = :vero

  def self.perform(api_class, domain, options)
    Vero::Senders::Base.new.call(api_class, domain, options)
  rescue => e
    Vero::App.log_api_call(api_class, options, e.message)
  end
end
