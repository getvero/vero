# frozen_string_literal: true

class VeroGenerator < Rails::Generators::Base
  class_option :heroku
  class_option :api_key
  class_option :api_secret

  def create_initializer_file
    type = options[:heroku] || 'standard'

    abort('You must provide an API KEY and API SECRET to proceed.') if options[:heroku].blank? && (options[:api_key].blank? || options[:api_secret].blank?)
    create_file 'config/initializers/vero.rb', send("#{type}_initializer_content".to_sym)
  end

  private

  def standard_initializer_content
    <<~END_TEXT
      Vero::App.init do |config|
        config.api_key  = '#{options[:api_key]}'
        config.secret   = '#{options[:api_secret]}'
      end
    END_TEXT
  end

  def heroku_initializer_content
    <<~END_TEXT
      Vero::App.init do |config|
        config.api_key  = ENV['VERO_API_KEY']
        config.secret   = ENV['VERO_API_SECRET']
      end
    END_TEXT
  end
end
