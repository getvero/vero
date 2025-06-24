# frozen_string_literal: true

require "resque"

class Vero::ResqueWorker
  @queue = :vero

  def self.perform(api_class, domain, options)
    Vero::Senders::Base.new.call(api_class, domain, options)
  rescue => e
    Vero::App.log(self, "method: #{api_class}, options: #{options.to_json}, response: #{e.message}")
  end
end
