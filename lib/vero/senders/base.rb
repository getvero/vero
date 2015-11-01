module Vero
  module Senders
    class Base
      def call(api_class, domain, options)
        response = api_class.perform(domain, options)
        Vero::App.log(self, "method: #{api_class.name}, options: #{JSON.dump(options)}, response: job performed")
        response
      end
    end
  end
end
