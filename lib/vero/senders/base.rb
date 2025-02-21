# frozen_string_literal: true

class Vero::Senders::Base
  def call(api_class, domain, options)
    api_class = get_api_class(api_class)

    resp = enqueue_work(api_class, domain, options)
    Vero::App.log(self, "method: #{api_class.name}, options: #{JSON.dump(options)}, response: #{log_message}")

    resp
  end

  def enqueue_work(api_class, domain, options)
    api_class.perform(domain, options)
  end

  def log_message
    "job performed"
  end

  def get_api_class(klass_name)
    return klass_name unless klass_name.is_a?(String)

    if Object.const_defined?(klass_name)
      Object.const_get(klass_name)
    else
      raise ArgumentError, "Invalid API class name: #{klass_name}"
    end
  end
end
