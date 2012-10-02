require 'girl_friday'

module Vero
  module Senders
    class Thread
      VERO_SENDER_QUEUE ||= ::GirlFriday::WorkQueue.new(:vero_queue, :size => 1) do |msg|
        api_class = msg[:api_class]
        domain    = msg[:domain]
        options   = msg[:options]

        begin
          api_class.perform(domain, options)
          Vero::App.log(self, "method: #{api_class.name}, options: #{options.to_json}, response: job performed")
        rescue => e
          Vero::App.log(self, "method: #{api_class.name}, options: #{options.to_json}, response: #{e.message}")
        end
      end

      def call(api_class, domain, options)
        !!VERO_SENDER_QUEUE.push(:api_class => api_class, :domain => domain, :options => options)
      end
    end
  end
end