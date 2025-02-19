# frozen_string_literal: true

class VeroGenerator < Rails::Generators::Base
  def create_initializer_file
    create_file("config/initializers/vero.rb", <<~INITIALIZER)
      Vero::App.init do |config|
        config.tracking_api_key = ENV['VERO_TRACKING_API_KEY']
      end
    INITIALIZER
  end
end
