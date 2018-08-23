# Topic model
class Topic < ActiveRecord::Base
  belongs_to :course
  has_many :users_topics
  has_many :users, through: :users_topics
end
