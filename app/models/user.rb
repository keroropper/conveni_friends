class User < ApplicationRecord
  has_many :recruits, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_recruits, through: :favorites, source: :recruit
  has_one_attached :profile_photo, dependent: :destroy
  before_save :downcase_email
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  validates :name, presence: true, length: { maximum: 10 }
  validates :age, presence: true, numericality: { only_integer: true }
  validates :email, uniqueness: { case_sensitive: false }
  validates :introduce, length: { maximum: 400 }

  def active_for_authentication?
    super && activated?
  end

  def after_confirmation
    update_attribute(:activated, true)
  end

  def update_profile_image(new_image)
    if new_image
      profile_photo.attach(new_image)
    else
      profile_photo.purge
    end
  end

  def favorite_by?(recruit_id)
    favorites.exists?(recruit_id:)
  end

  private

  def downcase_email
    email.downcase!
  end
end
