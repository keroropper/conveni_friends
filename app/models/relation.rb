class Relation < ApplicationRecord
  belongs_to :followed, class_name: "User"
  belongs_to :follower, class_name: "User"
  validates :followed_id, uniqueness: { scope: :follower_id }
  validates :follower_id, uniqueness: { scope: :followed_id }
  validate :cannot_follow_self, on: :create

  private

  def cannot_follow_self
    errors.add(:base, '自分自身をフォローすることはできません。') if follower_id == followed_id
  end
end
