class Topics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.integer :course_id, null: false, :limit => 8, index: true
      t.string :title, index: true, null: false
      t.string :description, index: true, null: false
      t.string :url, null: false
      t.timestamps
    end
    add_foreign_key :topics, :courses, on_delete: :cascade
  end
end
