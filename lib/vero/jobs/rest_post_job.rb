require 'rest-client'

module Vero
  module Jobs
    class RestPostJob < Struct.new(:url, :params)
      def perform
        RestClient.post(url, params)
      end
    end
  end
end