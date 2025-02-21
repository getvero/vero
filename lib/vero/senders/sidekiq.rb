class Vero::Senders::Sidekiq < Vero::Senders::Base
  def enqueue_work(api_class, domain, options)
    ::Vero::SidekiqWorker.perform_async(api_class.to_s, domain, options)
  end

  def log_message
    "sidekiq job queued"
  end
end
