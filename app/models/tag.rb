class Tag < ApplicationRecord
  has_many :recruit_tags, dependent: :destroy

  validate :validate_tag_count

  def validate_tag_count
    tag_count = name.split(/[[:blank:]]+/).count(&:present?)
    errors.add(:name, "は3つまでしか登録できません") if tag_count > 3
  end
end
