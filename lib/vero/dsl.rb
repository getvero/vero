# frozen_string_literal: true

module Vero
  ##
  # A lightweight DSL for using the Vero API. You may find this desirable in
  # your Rails controllers having decided not to mix the Vero gem directly into
  # your models.
  #
  # Example usage:
  #
  #   class UsersController < ApplicationController
  #     include Vero::DSL
  #
  #     def update
  #       vero.users.track!({ ... })
  #     end
  #   end
  module DSL
    def vero
      @vero ||= Proxy.new
    end

    # :nodoc:
    class Proxy
      include Vero::Api

      def users
        Users
      end

      def events
        Events
      end
    end
  end
end
