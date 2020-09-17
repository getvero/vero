# frozen_string_literal: true

require 'json'

module Vero
  class SenderHash < ::Hash
    def [](key)
      if key?(key)
        super
      else
        klass_name = key.to_s.split('_').map(&:capitalize).join
        Vero::Senders.const_get(klass_name)
      end
    end
  end

  class Sender
    def self.senders
      t = Vero::SenderHash.new

      t.merge!({
                 true => Vero::Senders::Invalid,
                 false => Vero::Senders::Base,
                 :none => Vero::Senders::Base
               })

      if RUBY_VERSION !~ /1\.8\./
        t.merge!(
          true => Vero::Senders::Base
        )
      end

      t
    end

    def self.send(api_class, sender_strategy, domain, options)
      sender_class = senders[sender_strategy] || senders[false]

      sender_class.new.call(api_class, domain, options)
    rescue StandardError => e
      options_s = JSON.dump(options)
      Vero::App.log(new, "method: #{api_class.name}, options: #{options_s}, error: #{e.message}")
      raise e
    end
  end
end
