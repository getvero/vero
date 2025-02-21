class Vero::Senders::Resque
  def call(api_class, domain, options)
    ::Resque.enqueue(::Vero::ResqueWorker, api_class.to_s, domain, options)
  end
end
