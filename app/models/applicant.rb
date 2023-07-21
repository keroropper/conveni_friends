class Applicant < ApplicationRecord
  belongs_to :user
  belongs_to :recruit

  validates :recruit_id, uniqueness: { scope: :user_id }
  validate :not_applicant_own_recruit

  private

  def not_applicant_own_recruit
    if user == recruit.user
      errors.add(:base, "You can't apply to your own recruit.")
    end
  end
end
