class Users < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :fname, index: true, null: false
      t.string :lname, index: true, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :password_digest, null: false
      t.timestamps
    end
  end
end
