# Category model
class Category < ActiveRecord::Base
  has_many :courses

  name_message = 'Name must be 2-20 characters and alphanumeric.'
  description_message = 'Description must be 50-1000 characters long.'

  validates :name,
    :presence => { message: 'Category Name Required' },
    :length => { in: 2..20, message: name_message },
    :format => { with: /\w{2,20}/, message: name_message },
    :uniqueness => { case_sensitive: false, message: 'Category already exists!' }

  validates :description,
    :presence => { message: 'Description required' },
    :length => { in: 50..1000, message: description_message },
    :format => { with: /\w{2,20}/, message: description_message }
end
