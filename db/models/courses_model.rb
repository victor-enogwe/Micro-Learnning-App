# Courses model
class Course < ActiveRecord::Base
  has_many :users_courses
  has_many :users, through: :users_courses
  has_many :topics

  validates :title, :presence => true, :length => { in: 5..100 }, :format => /\w+/
  validates :description, :presence => true, :length => { in: 50..1000 }, :format => /\w+/
end
