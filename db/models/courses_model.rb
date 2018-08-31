# Courses model
class Course < ActiveRecord::Base
  has_many :user_courses
  has_many :users, through: :user_courses, dependent: :destroy
  belongs_to :category
  belongs_to :user, :class_name => :User, :foreign_key => 'creator_id'
  has_many :topics, dependent: :destroy

  creator_message = 'creator id/category id must be a positive integer'
  title_message = 'Title must be 5-100 characters and alphanumeric.'
  description_message = 'Description must be 50-1000 characters long.'

  validates :creator_id, :category_id,
    :presence => { message: 'Id Required' },
    :numericality => { only_integer: true, greater_than: 0, message: creator_message }
  validates :title,
    :presence =>{ message: 'Title required' },
    :length => { in: 5..100, message: title_message }
  validates :description,
    :presence => { message: 'description required '},
    :length => { in: 50..1000, message: description_message }

  def as_json(options = {})
    super.tap do |hash|
      if options[:include]
        if options[:include].include? :'user'
          fname, lname, id = hash['user'].values_at 'fname', 'lname', 'id'
          hash[:creator] = { name: "#{fname} #{lname}", id: id }
          hash.delete 'user'
        end
      end
    end
  end
end
