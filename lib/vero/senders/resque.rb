class Vero::Senders::Resque < Vero::Senders::Base
  def enqueue_work(api_class, domain, options)
    ::Resque.enqueue(::Vero::ResqueWorker, api_class.to_s, domain, options)
  end

  def log_message
    "resque job queued"
  end
end
