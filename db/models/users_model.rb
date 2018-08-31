# User model
class User < ActiveRecord::Base
  has_secure_password
  has_many :user_courses
  has_many :courses, through: :user_courses, dependent: :destroy
  has_many :courses, :class_name => :Course, :foreign_key => 'creator_id'
  has_many :user_topics
  has_many :topics, through: :user_topics, dependent: :destroy
  has_many :user_permissions
  has_many :permissions, through: :user_permissions, dependent: :destroy

  password_message = 'Password length must be greater than 6'
  name_message = 'Name must bbe 2-20 alphabets long'


  validates :email,
    :presence => { message: 'Enter your email address!' },
    :format => { with: URI::MailTo::EMAIL_REGEXP, message: 'invalid Email!' },
    :uniqueness => { case_sensitive: false, message: 'Email already exists!' }

  validates :password,
    :presence => { message: password_message },
    :length => { minimum: 7, message: password_message  },
    :format => { with: /.{7,}/, message: password_message }

  validates :fname, :lname,
    :presence => { message: 'please enter your name' },
    :length => { in: 2..20, message: name_message },
    :format => { with: /[A-Za-z]{2,20}/, message: name_message }

  def self.select_without *columns
    self.select(self.attribute_names - columns.map(&:to_s))
  end

  def full_name
    self.fname + self.lname
  end
end
