# frozen_string_literal: true

require 'json'
require 'resque'

module Vero
  class ResqueWorker
    @queue = :vero

    def self.perform(api_class, domain, options)
      new_options = options.each_with_object({}) do |(k, v), o|
        o[k.to_sym] = v
      end

      api_class.constantize.new(domain, new_options).perform
      Vero::App.log(self, "method: #{api_class}, options: #{options.to_json}, response: resque job queued")
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
