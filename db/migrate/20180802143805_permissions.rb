class Permissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      t.string :name, null: false, index: { unique: true }
    end
  end
end
