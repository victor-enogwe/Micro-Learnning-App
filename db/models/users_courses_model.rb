# Users Courses model
class UsersCourse < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validates :learning_interval_days,
    :inclusion => 1..10,
    :presence => { message: 'learning interval in days required' }
  validates :daily_delivery_time,
    :inclusion => 1..24,
    :presence => { message: 'Daily time of delivery required' }
  validates :last_sent_time,
    :presence => { message: 'Last Sent TimeStamp Required' }
end
