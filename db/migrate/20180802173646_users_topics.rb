class UsersTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :user_topics do |t|
      t.integer :course_id, null: false, :limit => 8, index: true
      t.integer :topic_id, null: false, :limit => 8, index: true
      t.integer :user_id, null: false, :limit => 8, index: true
      t.timestamps
    end
    add_foreign_key :user_topics, :users, on_delete: :cascade
    add_foreign_key :user_topics, :courses, on_delete: :cascade
    add_foreign_key :user_topics, :topics, on_delete: :cascade
  end
end
