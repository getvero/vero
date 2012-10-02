module Vero
  module Senders
    class Thread
      def call(api_class, domain, options)
        raise "#{self.class.name} does not support sending in another thread."
      end
    end
  end
end