require 'vero'

class User
  include Vero::Trackable
  trackable :email, :age

  def email
    'durkster@gmail.com'
  end

  def age
    20
  end
end

class UserWithoutEmail
  include Vero::Trackable
  trackable :email, :age

  def email; self.primary_contact; end

  def primary_contact
    'durkster@gmail.com'
  end

  def age
    20
  end
end

class UserWithEmailAddress
  include Vero::Trackable
  trackable :email_address, :age

  def email_address
    'durkster@gmail.com'
  end

  def age
    20
  end
end

class UserWithoutInterface
  include Vero::Trackable::Base
  trackable :email_address, :age

  def email_address
    'durkster@gmail.com'
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
    'durkster@gmail.com'
  end
  def age; nil; end
end