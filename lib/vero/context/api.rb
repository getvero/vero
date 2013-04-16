module Vero
  module APIContext
    def track!(event_name, event_data, extras = {})
      options = {:data => event_data, :event_name => event_name, :identity => subject.to_vero, :extras => extras}
      Vero::Api::Events.track!(options, self)
    end

    def identify!
      data    = subject.to_vero
      options = {:email => data[:email], :data => data}
      Vero::Api::Users.track!(options, self)
    end

    def update_user!(email = nil)
      changes = subject.to_vero
      options = {:email => (email || changes[:email]), :changes => changes}
      Vero::Api::Users.edit_user!(options, self)
    end

    def update_user_tags!(add = [], remove = [])
      identity  = subject.to_vero
      options   = {:email => identity[:email], :add => add, :remove => remove}
      Vero::Api::Users.edit_user_tags!(options, self)
    end

    def unsubscribe!
      identity  = subject.to_vero
      options   = {:email => identity[:email]}
      Vero::Api::Users.unsubscribe!(options, self)
    end
  end
end