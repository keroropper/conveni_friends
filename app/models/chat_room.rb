class ChatRoom < ApplicationRecord
  has_many :members, dependent: :destroy
  has_many :chat_messages, dependent: :destroy
  has_many :users, through: :member
end
