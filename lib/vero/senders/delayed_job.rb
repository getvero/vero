# frozen_string_literal: true

require "json"
require "delayed_job"

module Vero
  module Senders
    class DelayedJob
      def call(api_class, domain, options)
        response = ::Delayed::Job.enqueue api_class.new(domain, options)
        options_s = JSON.dump(options)
        Vero::App.log(self, "method: #{api_class.name}, options: #{options_s}, response: delayed job queued")
        response
      rescue => e
        raise "To send ratings asynchronously, you must configure delayed_job. Run `rails generate delayed_job:active_record` then `rake db:migrate`." if e.message == "Could not find table 'delayed_jobs'"

        raise e
      end
    end
  end
end
