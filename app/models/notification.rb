class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'User', inverse_of: :notifications

  default_scope -> { order(created_at: :desc) }
  validates :category, inclusion: { in: %w[comment applicant relation chat_message favorite] }
end
