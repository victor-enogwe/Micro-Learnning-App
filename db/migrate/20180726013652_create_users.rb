class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :fname
      t.string :lname
      t.string :email
      t.string :password_hash
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
