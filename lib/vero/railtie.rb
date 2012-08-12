require 'vero/view_helpers/javascript'

module Vero
  class Railtie < Rails::Railtie
    initializer "vero.view_helpers" do
      ActionView::Base.send :include, ViewHelpers::Javascript
    end
  end
end