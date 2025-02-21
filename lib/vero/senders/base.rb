# frozen_string_literal: true

class Vero::Senders::Base
  def call(api_class, domain, options)
    response = api_class.perform(domain, options)
    options_s = JSON.dump(options)
    Vero::App.log(self, "method: #{api_class.name}, options: #{options_s}, response: job performed")
    response
  end
end
