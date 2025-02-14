# frozen_string_literal: true

require "json"
require "sucker_punch"

module Vero
  class SuckerPunchWorker
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

  module Senders
    class SuckerPunch
      def call(api_class, domain, options)
        Vero::SuckerPunchWorker.perform_async(api_class, domain, options)
      end
    end
  end
end
