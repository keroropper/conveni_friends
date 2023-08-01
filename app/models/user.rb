class User < ApplicationRecord
  has_many :recruits, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_recruits, through: :favorites, source: :recruit
  has_many :applicants, dependent: :destroy
  has_many :applicant_recruits, through: :applicants, source: :recruit
  # 応募する側
  has_many :active_relations, class_name: 'Relation', foreign_key: :followed_id, dependent: :destroy, inverse_of: :followed
  has_many :followings, through: :active_relations, source: :follower
  # 応募される側
  has_many :passive_relations, class_name: 'Relation', foreign_key: :follower_id, dependent: :destroy, inverse_of: :follower
  has_many :followers, through: :passive_relations, source: :followed
  has_one_attached :profile_photo, dependent: :destroy
  has_many :members, dependent: :destroy
  has_many :chat_messages, dependent: :destroy
  has_many :chat_rooms, through: :members
  has_many :notifications, foreign_key: :receiver_id, dependent: :destroy, inverse_of: :sender
  has_many :evaluations, dependent: :destroy, foreign_key: :evaluatee_id, inverse_of: :evaluatee
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

  def follow(other_user, recruit)
    active_relations.create!(follower_id: other_user, recruit_id: recruit)
    applicant_user = Applicant.where(recruit_id: recruit).where.not(user_id: other_user)
    applicant_user.destroy_all
  end

  def relation_users
    (followings + followers).sort_by(&:created_at).reverse
  end

  def create_chat_room(other_user)
    room = ChatRoom.create
    Member.create(user_id: id, chat_room_id: room.id)
    Member.create(user_id: other_user, chat_room_id: room.id)
    room
  end

  def find_target_room(target_user)
    current_user_room = Member.where(user_id: id).pluck(:chat_room_id)
    target_user_room = Member.where(user_id: target_user).pluck(:chat_room_id)
    ChatRoom.find(current_user_room.intersection(target_user_room)[0])
  end

  def incomplete_evaluation_users
    relation = (passive_relations + active_relations)
    relation_recruit_ids = relation.pluck(:recruit_id)
    evaluated_recruits_id = Evaluation.where(evaluator_id: id).pluck(:recruit_id)
    relation_recruit_ids -= evaluated_recruits_id
    relation_recruits = Recruit.where(id: relation_recruit_ids)
    target_ids = relation_recruits.where("meeting_time < ? AND date <= ?", Time.current, Date.current).pluck(:id)
    target_relations = Relation.where(recruit_id: target_ids)
    my_relation_user_ids = []
    target_relations.each do |t|
      target_user_id = t.followed_id == id ? t.follower_id : t.followed_id
      my_relation_user_ids << target_user_id
    end
    User.where(id: my_relation_user_ids)
  end

  def update_score
    average_score = Evaluation.where(evaluatee_id: id).average(:score).to_f.truncate(2)
    new_score_count = score_count + 1
    update(score: average_score, score_count: new_score_count)
  end

  def delete_relation(partner, recruit_id)
    evaluator = Evaluation.find_by(recruit_id:, evaluator_id: id)
    evaluatee = Evaluation.find_by(recruit_id:, evaluatee_id: id)
    if evaluator.present? && evaluatee.present?
      # 関係性削除
      finder = TargetRecruitFinder.new(self, partner.id)
      target_recruit = finder.find_target_recruit
      target_relation = Relation.find_by(recruit_id: target_recruit.id)
      target_relation.delete
      # チャットルーム削除
      room = find_target_room(partner.id)
      room.delete
      # チャットメッセージ削除
      message = ChatMessage.where(chat_room_id: room.id)
      message.delete_all
      # 中間テーブル削除
      member = Member.where(chat_room_id: room.id)
      member.delete_all
    end
  end

  private

  def downcase_email
    email.downcase!
  end
end
