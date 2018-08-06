class UsersCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :users_courses do |t|
      t.belongs_to :user, index: true
      t.belongs_to :course, index: true
      t.integer :course_id, null: false, :limit => 8
      t.integer :user_id, null: false, :limit => 8
      t.datetime :registration_date, null: false
      t.timestamps
    end
  end
end
