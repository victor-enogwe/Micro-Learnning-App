class InstructorRequest < ActiveRecord::Migration[5.2]
  def change
    create_table :instructor_requests do |t|
      t.integer :user_id, null: false, :limit => 8, , index: { unique: true }
      t.boolean :approved, null: false, default: false
      t.timestamps
    end
    add_foreign_key :instructor_requests, :users, on_delete: :cascade
  end
end
