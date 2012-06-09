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