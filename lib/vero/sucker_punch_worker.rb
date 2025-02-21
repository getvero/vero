# frozen_string_literal: true

require "sucker_punch"

class Vero::SuckerPunchWorker
  include SuckerPunch::Job

  def perform(api_class, domain, options)
    new_options = {}
    options.each { |k, v| new_options[k.to_sym] = v }

    begin
      api_class.new(domain, new_options).perform
      Vero::App.log(self, "method: #{api_class.name}, options: #{options.to_json}, response: job performed")
    rescue => e
      Vero::App.log(self, "method: #{api_class.name}, options: #{options.to_json}, response: #{e.message}")
    end
  end
end
