class Courses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.integer :category_id, null: false, :limit => 8, index: true
      t.integer :creator_id, null: false, :limit => 8, index: true
      t.string :title, index: true, null: false
      t.string :description, null: false
      t.timestamps
    end
    add_foreign_key :courses, :users, column: :creator_id
    add_foreign_key :courses, :categories
  end
end
