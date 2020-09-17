# frozen_string_literal: true

require 'base64'

module Vero
  class Config
    attr_writer :domain
    attr_accessor :api_key, :secret, :development_mode, :async, :disabled, :logging

    def self.available_attributes
      %i[api_key secret development_mode async disabled logging domain]
    end

    def initialize
      reset!
    end

    def config_params
      { api_key: api_key, secret: secret }
    end

    def request_params
      {
        auth_token: auth_token,
        development_mode: development_mode
      }.reject { |_, v| v.nil? }
    end

    def domain
      if @domain.blank?
        'https://api.getvero.com'
      else
        @domain =~ %r{https?://.+} ? @domain : "http://#{@domain}"
      end
    end

    def auth_token
      return unless auth_token?

      ::Base64.encode64("#{api_key}:#{secret}").gsub(/[\n ]/, '')
    end

    def auth_token?
      !api_key.blank? && !secret.blank?
    end

    def configured?
      auth_token?
    end

    def disable_requests!
      self.disabled = true
    end

    def reset!
      self.disabled         = false
      self.development_mode = false
      self.async            = true
      self.logging          = false
      self.api_key          = nil
      self.secret           = nil
    end

    def update_attributes(attributes = {})
      return unless attributes.is_a?(Hash)

      Vero::Config.available_attributes.each do |symbol|
        method_name = "#{symbol}=".to_sym
        send(method_name, attributes[symbol]) if respond_to?(method_name) && attributes.key?(symbol)
      end
    end
  end
end
