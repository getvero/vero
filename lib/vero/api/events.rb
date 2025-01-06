# frozen_string_literal: true

class Vero::Api::Events < Vero::Api::Base
  def self.track!(options, context = Vero::App.default_context)
    new(context).track!(options)
  end

  def track!(options)
    run_api(Vero::Api::Workers::Events::TrackAPI, options)
  end
end
