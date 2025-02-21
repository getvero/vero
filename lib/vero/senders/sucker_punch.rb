class Vero::Senders::SuckerPunch < Vero::Senders::Base
  def enqueue_work(api_class, domain, options)
    ::Vero::SuckerPunchWorker.perform_async(api_class, domain, options)
  end

  def log_message
    "sucker punch job queued"
  end
end
