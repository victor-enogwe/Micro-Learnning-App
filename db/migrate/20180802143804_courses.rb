class Courses < ActiveRecord::Migration[5.2]
  def change
    create_table :courses do |t|
      t.string :name, index: true, null: false
      t.string :description, null: false
      t.timestamps
    end
  end
end
