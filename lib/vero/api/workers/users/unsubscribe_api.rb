# frozen_string_literal: true

class Vero::Api::Workers::Users::UnsubscribeAPI < Vero::Api::Workers::BaseAPI
  def url
    "#{@domain}/api/v2/users/unsubscribe.json"
  end

  def request_method
    :post
  end

  def validate!
    return unless options[:id].to_s.strip.empty? && options[:email].to_s.strip.empty?

    raise ArgumentError, "Missing :id or :email"
  end
end
