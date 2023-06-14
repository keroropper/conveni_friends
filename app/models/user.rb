class User < ApplicationRecord
  before_save :downcase_email
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }
  validates :age, presence: true
  validates :email, uniqueness: { case_sensitive: false }

  private

  def downcase_email
    email.downcase!
  end
end
