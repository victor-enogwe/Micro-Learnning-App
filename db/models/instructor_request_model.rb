# InstructorRequest model
class InstructorRequest < ActiveRecord::Base
  belongs_to :user

  user_message = 'user id must be a positive integer'

  validates :user_id,
    :presence => { message: 'Id Required' },
    :numericality => { only_integer: true, greater_than: 0, message: user_message }
end
