# frozen_string_literal: true

class Vero::App
  include Vero::Utility::Logger

  def self.default_context
    @@default_context ||= Vero::Context.new # rubocop:disable Style/ClassVars
  end

  def self.init(&block)
    default_context.configure(&block) if block
  end

  def self.reset!
    default_context.reset!
  end

  def self.disable_requests!
    default_context.disable_requests!
  end

  def self.configured?
    default_context.configured?
  end
end
