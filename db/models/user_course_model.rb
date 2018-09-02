# Users Courses model
class UserCourse < ActiveRecord::Base
  belongs_to :user
  belongs_to :course

  validate :valid_registration_date
  validates :learning_interval_days,
    :inclusion => 1..10,
    :presence => { message: 'learning interval in days required' }
  validates :daily_delivery_time,
    :inclusion => 1..24,
    :presence => { message: 'Daily time of delivery required' }

  def valid_registration_date
    message = 'must be a valid datetime'
    date = Time.at(registration_date).strftime('%Y-%m-%d %H:%M:%S')
    errors.add(:registration_date, message) if ((date rescue ArgumentError) == ArgumentError)
  end
end
