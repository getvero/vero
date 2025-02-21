# frozen_string_literal: true

class Vero::Api::Workers::Users::ReidentifyAPI < Vero::Api::Workers::BaseAPI
  def url
    "#{@domain}/api/v2/users/reidentify.json"
  end

  def request_method
    :put
  end

  def validate!
    raise ArgumentError, "Missing :id" if options[:id].to_s.strip.empty?
    raise ArgumentError, "Missing :new_id" if options[:new_id].to_s.strip.empty?
  end
end
