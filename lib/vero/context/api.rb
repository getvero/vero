# frozen_string_literal: true

module Vero
  module APIContext
    def track!(event_name, event_data, extras = {})
      options = {data: event_data, event_name: event_name, identity: subject.to_vero, extras: extras}
      Vero::Api::Events.track!(options, self)
    end

    def identify!
      identity = subject.to_vero
      options = {id: identity[:id], email: identity[:email], data: identity}
      Vero::Api::Users.track!(options, self)
    end

    def update_user!
      identity = subject.to_vero
      options = {id: identity[:id], email: identity[:email], changes: identity}
      Vero::Api::Users.edit_user!(options, self)
    end

    def update_user_tags!(add = [], remove = [])
      identity = subject.to_vero
      options = {id: identity[:id], email: identity[:email], add: Array(add), remove: Array(remove)}
      Vero::Api::Users.edit_user_tags!(options, self)
    end

    def unsubscribe!
      identity = subject.to_vero
      options = {id: identity[:id], email: identity[:email]}
      Vero::Api::Users.unsubscribe!(options, self)
    end

    def reidentify!(previous_id)
      identity = subject.to_vero
      options = {id: previous_id, new_id: identity[:id]}
      Vero::Api::Users.reidentify!(options, self)
    end
  end
end
