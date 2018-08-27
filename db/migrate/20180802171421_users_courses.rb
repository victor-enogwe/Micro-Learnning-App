class UsersCourses < ActiveRecord::Migration[5.2]
  def change
    create_table :users_courses do |t|
      t.belongs_to :user, index: true
      t.belongs_to :course, index: true
      t.integer :course_id, null: false, :limit => 8
      t.integer :user_id, null: false, :limit => 8
      t.datetime :registration_date, null: false
      t.integer :learning_interval_days, null: false, :default => 2, index: true
      t.integer :daily_delivery_time, null: false, :default => 24, index: true
      t.datetime :last_sent_time, null: false, index: true
      t.timestamps
    end
    add_foreign_key :users_courses, :users, on_delete: :cascade
    add_foreign_key :users_courses, :courses, on_delete: :cascade
  end
end
