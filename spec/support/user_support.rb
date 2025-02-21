# frozen_string_literal: true

require "vero"

class User
  include Vero::Trackable
  trackable :email, :age

  def email
    "user@getvero.com"
  end

  def age
    20
  end
end

class UserWithoutEmail
  include Vero::Trackable
  trackable :email, :age

  def email
    primary_contact
  end

  def primary_contact
    "user@getvero.com"
  end

  def age
    20
  end
end

class UserWithEmailAddress
  include Vero::Trackable
  trackable :email_address, :age

  def email_address
    "user@getvero.com"
  end

  def age
    20
  end
end

class UserWithoutInterface
  include Vero::Trackable::Base
  trackable :email_address, :age

  def email_address
    "user@getvero.com"
  end

  def age
    20
  end

  def vero_track(event_name, event_data)
    with_default_vero_context.track!(event_name, event_data)
  end
end

class UserWithNilAttributes
  include Vero::Trackable::Base
  trackable :email_address, :age

  def email_address
    "user@getvero.com"
  end

  def age
    nil
  end
end

class UserWithExtras
  include Vero::Trackable
  trackable :email, {extras: :properties}

  attr_accessor :properties

  def email
    "user@getvero.com"
  end
end

class UserWithPrivateExtras
  include Vero::Trackable
  trackable :email, {extras: :properties}

  def email
    "user@getvero.com"
  end

  private

  def properties
    {age: 26}
  end
end

class UserWithOnlyExtras
  include Vero::Trackable
  trackable({extras: :properties})

  attr_accessor :properties

  def email
    "user@getvero.com"
  end
end
