# Roles model
class Role < ActiveRecord::Base
  has_many :roles_permissions
  has_many :permissions, through: :roles_permissions

  validates :name, uniqueness: true
end
