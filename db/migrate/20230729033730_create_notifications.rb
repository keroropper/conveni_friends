class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.integer :sender_id, null: false
      t.integer :receiver_id, null: false
      t.string :category, null: false, default: ''
      t.integer :recruit_id
      t.boolean :read, default: false
      
      t.timestamps
    end
    add_index :notifications, :receiver_id
  end
end
