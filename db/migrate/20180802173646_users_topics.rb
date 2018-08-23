class UsersTopics < ActiveRecord::Migration[5.2]
  def change
    create_table :users_topics do |t|
      t.belongs_to :courses, index: true
      t.belongs_to :topics, index: true
      t.belongs_to :users, index: true
      t.integer :course_id, null: false, :limit => 8
      t.integer :topic_id, null: false, :limit => 8
      t.integer :users_id, null: false, :limit => 8
      t.timestamps
    end
  end
end
