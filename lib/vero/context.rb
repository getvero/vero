# frozen_string_literal: true

class Vero::Context
  include Vero::APIContext

  attr_accessor :config, :subject

  def initialize(object = {})
    if object.is_a?(Vero::Context)
      @config = object.config
      @subject = object.subject
      return
    end

    @config = Vero::Config.new

    object = Vero::Config.extract_accepted_attrs_from(object) unless object.is_a?(Hash)
    configure(object)
  end

  def configure(hash = {}, &block)
    @config.update_attributes(hash) if hash.is_a?(Hash) && hash.any?

    block&.call(@config)
  end

  def reset!
    @config.reset!
  end

  def disable_requests!
    @config.disable_requests!
  end

  def configured?
    @config.configured?
  end
end
