class Relation < ApplicationRecord
  belongs_to :followed, class_name: "User"
  belongs_to :follower, class_name: "User"
  validates :follower_id, :follower_id, :followed_id, presence: true
  validates :followed_id, uniqueness: { scope: :follower_id }
  validates :follower_id, uniqueness: { scope: :followed_id }
  validate :cannot_follow_self, on: :create

  private 
  
  def cannot_follow_self
    if follower_id == followed_id
      errors.add(:base, '自分自身をフォローすることはできません。')
    end
  end
end
