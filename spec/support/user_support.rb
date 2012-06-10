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