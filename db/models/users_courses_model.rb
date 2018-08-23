# Users Courses model
class UsersCourse < ActiveRecord::Base
  belongs_to :user
  belongs_to :course
end
