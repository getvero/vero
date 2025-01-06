# frozen_string_literal: true

class Vero::Config
  attr_writer :domain
  attr_accessor :tracking_api_key, :development_mode, :async, :disabled, :logging

  def self.available_attributes
    %i[tracking_api_key development_mode async disabled logging domain]
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
      development_mode: development_mode
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
    self.development_mode = false
    self.async = true
    self.logging = false
    self.tracking_api_key = nil
  end

  def update_attributes(attributes = {})
    return unless attributes.is_a?(Hash)

    Vero::Config.available_attributes.each do |symbol|
      method_name = "#{symbol}="
      send(method_name, attributes[symbol]) if respond_to?(method_name) && attributes.key?(symbol)
    end
  end
end
