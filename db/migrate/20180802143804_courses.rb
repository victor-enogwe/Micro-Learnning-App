class Courses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.integer :creator_id, null: false, :limit => 8
      t.string :title, index: true, null: false
      t.string :description, null: false
      t.timestamps
      # belongs_to :user, foreign_key: :creator_id
    end
  end
end
