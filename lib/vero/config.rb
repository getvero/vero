module Vero
  class Config
    attr_writer :domain
    attr_accessor :api_key, :secret, :development_mode, :async, :disabled, :logging

    def initialize
      self.reset!
    end

    def config_params
      options = {:api_key => self.api_key, :secret => self.secret}
    end

    def request_params
      temp = {}
      temp_auth_token         = self.auth_token
      temp[:auth_token]       = temp_auth_token       unless temp_auth_token.nil?
      temp[:development_mode] = self.development_mode unless self.development_mode.nil?

      temp
    end

    def domain
      @domain || 'www.getvero.com'
    end

    def auth_token
      return if api_key.blank? || secret.blank?
      Base64::encode64("#{api_key}:#{secret}").gsub(/[\n ]/, '')
    end

    def configured?
      !api_key.blank? && !secret.blank?
    end

    def reset!
      self.disabled         = false
      self.development_mode = !Rails.env.production?
      self.async            = true
      self.logging          = false
      self.api_key          = nil
      self.secret           = nil
    end
  end
end