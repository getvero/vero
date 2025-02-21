# frozen_string_literal: true

class Vero::Api::Workers::Users::EditAPI < Vero::Api::Workers::BaseAPI
  def url
    "#{@domain}/api/v2/users/edit.json"
  end

  def request_method
    :put
  end

  def validate!
    raise ArgumentError, "Missing :id or :email" if options[:id].to_s.strip.empty? && options[:email].to_s.strip.empty?

    raise ArgumentError, ":changes must be a Hash" unless options[:changes].is_a?(Hash)
  end
end
