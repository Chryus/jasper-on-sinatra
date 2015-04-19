require 'sinatra/security'

require_relative "../config/initializers/sequel"

class User < Sequel::Model
  include Sinatra::Security

  self.raise_on_save_failure = false
  plugin :timestamps, update_on_create: true

  def authenticate(attempted_password) # sinatra security
    if Password::Hashing.check(attempted_password, self.password)
      true
    else
      false
    end
  end

  def before_save # sequel hook
    if password
      tmp = self.password
      self.password = Password::Hashing.encrypt(tmp)
    end
    super
  end

private
  
  def validate # sinatra security
    super

    validates_presence [:username, :password]
    validates_unique :username
  end
end

