require 'json'
require 'resque'

module Vero
  class ResqueWorker
    @queue = :vero

    def self.perform(api_class_name, domain, options)
      api_class = eval(api_class_name)
      new_options = {}
      options.each do |k,v|
        new_options[k.to_sym] = v
      end

      api_class.new(domain, new_options).perform
      Vero::App.log(self, "method: #{api_class.name}, options: #{options.to_json}, response: resque job queued")
    end
  end

  module Senders
    class Resque
      def call(api_class, domain, options)
        ::Resque.enqueue(ResqueWorker, api_class.to_s, domain, options)
      end
    end
  end
end