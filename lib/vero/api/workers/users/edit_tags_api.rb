# frozen_string_literal: true

class Vero::Api::Workers::Users::EditTagsAPI < Vero::Api::Workers::BaseAPI
  def url
    "#{@domain}/api/v2/users/tags/edit.json"
  end

  def request_method
    :put
  end

  def validate!
    raise ArgumentError, "Missing :id or :email" if options[:id].to_s.strip.empty? && options[:email].to_s.strip.empty?

    raise ArgumentError, ":add must be an Array if present" unless options[:add].nil? || options[:add].is_a?(Array)

    unless options[:remove].nil? || options[:remove].is_a?(Array)
      raise ArgumentError, ":remove must be an Array if present"
    end

    return unless options[:remove].nil? && options[:add].nil?

    raise ArgumentError, "Either :add or :remove must be present"
  end
end
