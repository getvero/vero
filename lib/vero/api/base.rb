# frozen_string_literal: true

class Vero::Api::Base
  attr_accessor :context

  def initialize(context)
    self.context = context
  end

  def config
    context.config
  end

  def run_api(api_klass, options)
    return if config.disabled

    validate_configured!
    options.merge!(config.request_params)
    Vero::Sender.call(api_klass, config.async, config.domain, options)
  end

  protected

  def validate_configured!
    return if config.configured?

    raise "You must configure the 'vero' gem. Visit https://github.com/getvero/vero for more details."
  end
end
