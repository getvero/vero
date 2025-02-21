class Vero::Senders::Sidekiq
  def call(api_class, domain, options)
    response = ::Vero::SidekiqWorker.perform_async(api_class.to_s, domain, options)
    Vero::App.log(self, "method: #{api_class.name}, options: #{options.to_json}, response: sidekiq job queued")
    response
  end
end
