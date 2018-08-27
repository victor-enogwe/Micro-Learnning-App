class Categories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name, index: { unique: true }, null: false
      t.string :description, index: true, null: false
      t.timestamps
    end
  end
end
