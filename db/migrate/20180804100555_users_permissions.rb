class UsersPermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :users_permissions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :permission, index: true
      t.integer :permission_id, null: false, :limit => 8
      t.integer :user_id, null: false, :limit => 8
    end
  end
end
