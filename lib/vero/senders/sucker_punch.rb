class Vero::Senders::SuckerPunch
  def call(api_class, domain, options)
    ::Vero::SuckerPunchWorker.perform_async(api_class, domain, options)
  end
end
