class Topics < ActiveRecord::Migration[5.2]
  def change
    create_table :topics do |t|
      t.string :name, index: true, null: false
      t.string :description, null: false
      t.string :url, null: false
      t.timestamps
    end
  end
end
