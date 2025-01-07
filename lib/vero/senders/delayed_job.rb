# frozen_string_literal: true

require "delayed_job"

class Vero::Senders::DelayedJob
  def call(api_class, domain, options)
    response = ::Delayed::Job.enqueue api_class.new(domain, options)

    Vero::App.log(self, "method: #{api_class.name}, options: #{JSON.dump(options)}, response: delayed job queued")
    response
  rescue => e
    raise "To send ratings asynchronously, you must configure delayed_job. Run `rails generate delayed_job:active_record` then `rake db:migrate`." if e.message == "Could not find table 'delayed_jobs'"

    raise e
  end
end
