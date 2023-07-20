class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :recruit

  validates :recruit_id, uniqueness: { scope: :user_id }
end
