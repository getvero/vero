# frozen_string_literal: true

class Vero::Api::Workers::Users::TrackAPI < Vero::Api::Workers::BaseAPI
  def url
    "#{@domain}/api/v2/users/track.json"
  end

  def request_method
    :post
  end

  def validate!
    raise ArgumentError, "Missing :id or :email" if options[:id].to_s.strip.empty? && options[:email].to_s.strip.empty?

    return if options[:data].nil? || options[:data].is_a?(Hash)

    raise ArgumentError, ":data must be either nil or a Hash"
  end
end
