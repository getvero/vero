# frozen_string_literal: true

class Vero::Context
  include Vero::APIContext

  attr_accessor :config, :subject

  def initialize(object = {})
    case object
    when Hash
      # stub
    when Vero::Context
      @config = object.config
      @subject = object.subject
    else
      object = Vero::Config.available_attributes.each_with_object({}) do |symbol, hash|
        hash[symbol] = object.respond_to?(symbol) ? object.send(symbol) : nil
      end
    end
    return unless object.is_a?(Hash)

    @config = Vero::Config.new
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
