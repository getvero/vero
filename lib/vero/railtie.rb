require 'vero/view_helpers'
module Vero
  class Railtie < Rails::Railtie
    initializer "vero.view_helpers" do
      ActionView::Base.send :include, ViewHelpers
    end
  end
end