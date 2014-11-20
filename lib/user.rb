require 'bcrypt'
# this generates the password hash

class User

  include DataMapper::Resource

  attr_reader :password
  attr_accessor :password_confirmation
  # DataMapper needs to access both of these
  # to be sure that they are the same

  validates_confirmation_of :password, :message => "Sorry, your passwords don't match"
  # this is a DataMapper method
  # the model will not be saved unless both
  # password and password_confirmation
  # are the same

  property :id,     Serial
  property :email,  String, :unique => true, :message => "This email is already taken"
  # this will store both the password and the salt
  # it Text because a String holds 50 characters
  # by default which is not enough for the hash and salt
  # SQL will generate a unique index for the email field.
  # due to the unique handle
  # hence validates_uniqueness_of :email not necessary for 
  # this ORM (others may need it)
  property :password_digest, Text
  # when assigned the password, it is not stored directly
  # instead, a password digest is generated
  # ie. a big string
  # that is saved in the database
  # the digest, provided by bcrypt, has both 
  # the password and the salt
  # We save it to the database instead of as a plain
  # password for security reasons.
  property :password_token,           Text
  property :password_token_timestamp, DateTime

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def self.authenticate(email, password)
    # i.e. the user who is trying to sign in
    user = first(:email => email)
    # if this user exists and the password provided matches
    # the one we have password_digest for, everything is fine.

    if user && BCrypt::Password.new(user.password_digest) == password
      user
    else
      nil
    end
    # comparing two passwords directly is impossible
    # because we only have a one-way hash.
    # so here, what Password.new is doing is calculating 
    # a calculating the password_digest from the 
    # password given and comparing it to the password_digest
    # with which it was initialised
  end

end