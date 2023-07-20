class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :recruit
  validates :text, presence: true
  default_scope -> { order(created_at: :desc) }
end
