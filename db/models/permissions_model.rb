# Permission class model
class Permission < ActiveRecord::Base
  has_many :users_permissions
  has_many :users, through: :users_permissions, dependent: :destroy
  has_many :roles_permissions
  has_many :roles, through: :roles_permissions, dependent: :destroy

  name_message = 'permission must have a unique name'
  name_length_message = 'permission name must be 2-20 alphabetic characters'

  validates :name,
    uniqueness: { message: name_message },
    :presence => { message: name_message },
    :length => { minimum: 2, message: name_length_message  },
    :format => { with: /[A-za-z]{2,20}/, message: name_length_message }
end
