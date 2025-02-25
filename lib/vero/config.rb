# frozen_string_literal: true

class Vero::Config
  attr_writer :development_mode # Deprecated field

  attr_writer :domain
  attr_accessor :tracking_api_key, :async, :disabled, :logging, :http_timeout

  ACCEPTED_ATTRIBUTES = %i[tracking_api_key async disabled logging domain http_timeout]

  # Extracts accepted attributes from the given object. It isn't necessarily a Vero::Config instance.
  def self.extract_accepted_attrs_from(object)
    Vero::Config::ACCEPTED_ATTRIBUTES.each_with_object({}) do |method_name, hash|
      hash[method_name] = object.public_send(method_name) if object.respond_to?(method_name)
    end
  end

  def initialize
    reset!
  end

  def config_params
    {tracking_api_key: tracking_api_key}
  end

  def request_params
    {
      tracking_api_key: tracking_api_key,
      _config: {http_timeout: http_timeout}
    }.compact
  end

  def domain
    if @domain.nil? || @domain.to_s.empty?
      "https://api.getvero.com"
    else
      a_domain = @domain.to_s
      %r{https?://.+}.match?(a_domain) ? a_domain : "http://#{a_domain}"
    end
  end

  def configured?
    !tracking_api_key.blank?
  end

  def disable_requests!
    self.disabled = true
  end

  def reset!
    self.disabled = false
    self.async = true
    self.logging = false
    self.tracking_api_key = nil
    self.http_timeout = Vero::HttpClient::DEFAULT_HTTP_TIMEOUT
  end

  def update_attributes(attributes = {})
    return unless attributes.is_a?(Hash)

    Vero::Config::ACCEPTED_ATTRIBUTES
      .select { |attr| attributes.key?(attr) }
      .each { |attr| public_send(:"#{attr}=", attributes[attr]) }
  end
end
