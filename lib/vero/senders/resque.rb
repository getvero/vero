require 'json'

module Vero
  module Senders
    class Resque
      def call(api_class, domain, options)
        ::Resque.enqueue(api_class, domain, options)
      end
    end
  end
end