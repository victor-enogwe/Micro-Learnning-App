# Topic model
class Topic < ActiveRecord::Base
  belongs_to :course
  has_many :users_topics
  has_many :users, through: :users_topics, dependent: :destroy

  title_message = 'Title must be 5-100 characters and alphanumeric.'
  description_message = 'Description must be 50-1000 characters long.'

  validates :title,
    :presence =>{ message: 'Title required' },
    :length => { in: 5..100, message: title_message },
    :format => { with: /\w{5,100}/, message: title_message }
  validates :description,
    :presence => { message: 'description required '},
    :length => { in: 50..1000, message: description_message },
    :format => { with: /\w+/, message: description_message }
  validates :url,
    :presence => { message: 'URL required' },
    :format => { with: URI.regexp(%w[http https]), message: 'invalid URL!' }
end
