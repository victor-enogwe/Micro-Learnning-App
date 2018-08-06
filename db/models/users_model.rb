require 'bcrypt'

# User model
class User < ActiveRecord::Base
  # users.password_hash in the database is a :string
  include BCrypt

  has_many :users_courses
  has_many :courses, through: :users_courses
  has_many :users_topics
  has_many :topics, through: :users_topics
  has_many :users_permissions
  has_many :permissions, through: :users_permissions

  validates :email,
    :presence => { message: 'Enter your email address!' },
    :format => { with: URI::MailTo::EMAIL_REGEXP, message: 'invalid Email!' },
    :uniqueness => { case_sensitive: false, message: 'Email already exists!' }

  validates :password,
    :presence => { message: 'Password length must be greater than 6' },
    :length => { minimum: 7 },
    :format => { with: /\w+/, message: '' }

  validates :fname, :lname,
    :presence => true,
    :length => { in: 2..20 },
    :format => /\w+/

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end
