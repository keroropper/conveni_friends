class Applicant < ApplicationRecord
  belongs_to :user
  belongs_to :recruit

  validates :recruit_id, uniqueness: { scope: :user_id }
  validate :not_applicant_own_recruit

  private

  def not_applicant_own_recruit
    return if recruit_id.nil?

    recruit = Recruit.find(recruit_id)
    errors.add(:base, "You can't apply to your own recruit.") if recruit.user_id == user_id
  end
end
