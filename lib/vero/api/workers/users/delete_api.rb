# frozen_string_literal: true

class Vero::Api::Workers::Users::DeleteAPI < Vero::Api::Workers::BaseAPI
  def url
    "#{@domain}/api/v2/users/delete.json"
  end

  def request
    RestClient.post(url, @options)
  end

  def validate!
    raise ArgumentError, "Missing :id" if options[:id].to_s.strip.empty?
  end
end
