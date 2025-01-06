# frozen_string_literal: true

class Vero::Api::Workers::Events::TrackAPI < Vero::Api::Workers::BaseAPI
  def url
    "#{@domain}/api/v2/events/track.json"
  end

  def request
    RestClient.post(url, request_params_as_json, request_content_type)
  end

  def validate!
    raise ArgumentError, "Missing :event_name" if options[:event_name].to_s.strip.empty?
    raise ArgumentError, ":data must be either nil or a Hash" unless options[:data].nil? || options[:data].is_a?(Hash)
  end
end
