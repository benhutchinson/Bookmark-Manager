require 'bcrypt'
# this generates the password hash

class User

  include DataMapper::Resource

  attr_reader :password
  attr_accessor :password_confirmation
  # DataMapper needs to access both of these
  # to be sure that they are the same

  validates_confirmation_of :password
  # this is a DataMapper method
  # the model will not be saved unless both
  # password and password_confirmation
  # are the same

  property :id,     Serial
  property :email,  String
  # this will store both the password and the salt
  # it Text because a String holds 50 characters
  # by default which is not enough for the hash and salt
  property :password_digest, Text
  # when assigned the password, it is not stored directly
  # instead, a password digest is generated
  # ie. a big string
  # that is saved in the database
  # the digest, provided by bcrypt, has both 
  # the password and the salt
  # We save it to the database instead of as a plain
  # password for security reasons.

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

end