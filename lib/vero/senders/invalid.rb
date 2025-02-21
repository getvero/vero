# frozen_string_literal: true

class Vero::Senders::Invalid
  def call(_api_class, _domain, _options)
    raise "Vero sender not supported by your version of Ruby. Please change `config.async` to a valid sender. See https://github.com/getvero/vero for more information."
  end
end
