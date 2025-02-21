# frozen_string_literal: true

require "sucker_punch"

class Vero::SuckerPunchWorker
  include SuckerPunch::Job

  def perform(api_class, domain, options)
    Vero::Senders::Base.new.call(api_class, domain, options)
  rescue => e
    Vero::App.log(self, "method: #{api_class}, options: #{options.to_json}, response: #{e.message}")
  end
end
