class CreateMembers < ActiveRecord::Migration[6.1]
  def change
    create_table :members do |t|
      t.integer :user_id, null: false
      t.integer :chat_room_id, null: false
      t.timestamps
    end
  end
end
