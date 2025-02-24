class Vero::Senders::Sidekiq < Vero::Senders::Base
  def enqueue_work(api_class, domain, options)
    options = deep_transform(options)
    ::Vero::SidekiqWorker.perform_async(api_class.to_s, domain, options)
  end

  def log_message
    "sidekiq job queued"
  end

  private

  # Sidekiq workers args must safely serialize to JSON. Therefore all symbols must be
  # converted to strings.
  # A future version of the gem should standardize on string keys throughout.
  def deep_transform(hash)
    hash.each_with_object({}) do |(key, value), new_hash|
      key = transform_value(key)
      new_hash[key] = transform_value(value)
    end
  rescue
    # If there is an exception in this method, fallback to naive transform.
    JSON.parse hash.to_json
  end

  def transform_value(val)
    case val
    when Hash
      deep_transform(val)
    when Symbol
      val.to_s
    when Array, Set
      val.map { transform_value(_1) }
    when Time, Date, DateTime
      val.iso8601
    else
      val
    end
  end
end
