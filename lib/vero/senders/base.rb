require 'json'

module Vero
  module Senders
    class Base
      def call(api_class, domain, options, _config)
        response = api_class.perform(domain, options)
        options_s = JSON.dump(options)
        Vero::App.log(self, "method: #{api_class.name}, options: #{options_s}, response: job performed")
        response
      end
    end
  end
end
