# frozen_string_literal: true

require "resque"

class Vero::ResqueWorker
  @queue = :vero

  def self.perform(api_class, domain, options)
    new_options = options.transform_keys(&:to_sym)

    api_class.constantize.new(domain, new_options).perform

    Vero::App.log(self, "method: #{api_class}, options: #{options.to_json}, response: resque job queued")
  end
end
