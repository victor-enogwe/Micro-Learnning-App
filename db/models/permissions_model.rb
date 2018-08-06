# Permission class model
class Permission < ActiveRecord::Base
  has_many :users_permissions
  has_many :users, through: :users_permissions
  has_many :roles_permissions
  has_many :roles, through: :roles_permissions

  validates :name, uniqueness: true
end
