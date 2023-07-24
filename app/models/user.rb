class User < ApplicationRecord
  has_many :recruits, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_recruits, through: :favorites, source: :recruit
  has_many :applicants, dependent: :destroy
  has_many :applicant_recruits, through: :applicants, source: :recruit
  # 応募する側
  has_many :active_relations, class_name: 'Relation', foreign_key: :followed_id
  has_many :followings, through: :active_relations, source: :follower
  # 応募される側
  has_many :passive_relations, class_name: 'Relation', foreign_key: :follower_id
  has_many :followers, through: :passive_relations, source: :followed 
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

  def applicant_by?(recruit_id)
    applicants.exists?(recruit_id:)
  end

  def applicant_user?(current_user)
    return false if self == current_user

    app_rec = applicant_recruits
    true if app_rec.present? && (app_rec & current_user.recruits)
  end

  # 自分が応募済みかどうかを検証
  def followed_by?(user)
    passive_relations.find_by(followed_id: user.id).present?
  end

  private

  def downcase_email
    email.downcase!
  end
end
