class UsersPermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :user_permissions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :permission, index: true
      t.integer :permission_id, null: false, :limit => 8
      t.integer :user_id, null: false, :limit => 8
    end
    add_foreign_key :user_permissions, :users, on_delete: :cascade
    add_foreign_key :user_permissions, :permissions, on_delete: :cascade
  end
end
