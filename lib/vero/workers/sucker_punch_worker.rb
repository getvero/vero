# frozen_string_literal: true

require "sucker_punch"

class Vero::SuckerPunchWorker
  include SuckerPunch::Job

  def perform(api_class, domain, options)
    Vero::Senders::Base.new.call(api_class, domain, options)
  rescue => e
    Vero::App.log_api_call(api_class, options, e.message)
  end
end
