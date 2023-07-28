class CreateChatMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :chat_messages do |t|
      t.string :content, null: false, default: ''
      t.integer :chat_room_id, null: false
      t.integer :user_id, null: false
      t.timestamps
    end
  end
end
