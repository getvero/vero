# frozen_string_literal: true

require "delayed_job"

class Vero::Senders::DelayedJob < Vero::Senders::Base
  def enqueue_work(api_class, domain, options)
    ::Delayed::Job.enqueue api_class.new(domain, options)
  rescue => e
    if e.message == "Could not find table 'delayed_jobs'"
      raise "To send requests asynchronously, you must configure delayed_job. Run `rails generate delayed_job:active_record` then `rake db:migrate`."
    end

    raise e
  end

  def log_message
    "delayed job queued"
  end
end
