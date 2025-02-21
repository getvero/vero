# frozen_string_literal: true

module Vero
  class Railtie < Rails::Railtie
    initializer "vero.view_helpers" do
      ActionView::Base.include Vero::ViewHelpers::Javascript
    end
  end
end
