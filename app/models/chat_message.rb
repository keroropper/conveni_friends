class ChatMessage < ApplicationRecord
  belongs_to :user
  belongs_to :chat_room
  validates :content, presence: true

  # after_create_commit { ChatMessageBroadcastJob.perform_later self }
end
