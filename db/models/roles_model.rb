# Roles model
class Role < ActiveRecord::Base
  has_many :role_permissions
  has_many :permissions, through: :role_permissions

  name_message = 'role must have a unique name'
  name_length_message = 'role name must be 2-20 alphabetic characters'

  validates :name,
    uniqueness: { message: name_message },
    :presence => { message: name_message },
    :length => { minimum: 2, message: name_length_message  },
    :format => { with: /[A-za-z]{2,20}/, message: name_length_message }
end
