# User Topic model
class UserTopic < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  belongs_to :course
end
