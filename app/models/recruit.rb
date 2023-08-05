class Recruit < ApplicationRecord
  scope :active, -> { where(deleted_at: nil) }
  scope :with_user, ->(keyword) { joins(:user).where('title LIKE ?', "%#{keyword}%") if keyword.present? }
  scope :with_address, ->(address) { where('address LIKE ?', "%#{address}%") if address.present? }
  scope :with_tags, ->(tags) { joins(:tags).where(tags: { name: tags }) if tags.present? }
  scope :with_date, ->(date) { where('date LIKE ?', date.to_s) if date.present? }
  scope :with_meeting_time, ->(meeting_time) { where('meeting_time LIKE ?', "#{meeting_time}%") if meeting_time.present? }
  scope :with_required_time, ->(required_time) { where('required_time LIKE ?', required_time.to_s) if required_time.present? }
  scope :with_age_range, lambda { |start_age, end_age|
    if start_age.present? && end_age.present?
      if start_age > end_age
        joins(:user).where('age BETWEEN ? AND ?', end_age, start_age)
      else
        joins(:user).where('age BETWEEN ? AND ?', start_age, end_age)
      end
    elsif start_age.present?
      joins(:user).where('age >= ?', start_age)
    elsif end_age.present?
      joins(:user).where('age <= ?', end_age)
    end
  }
  scope :with_score, ->(score) { joins(:user).where('score LIKE ?', score.to_s) if score.present? && score != '0' }
  # Ex:- scope :active, -> {where(:active => true)}
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :recruit_tags, dependent: :destroy
  has_many :tags, through: :recruit_tags
  has_many :favorites, dependent: :destroy
  has_many :favorites_users, through: :favorites, source: :user
  has_many :applicants, dependent: :destroy
  has_many :applicant_users, through: :applicants, source: :user
  accepts_nested_attributes_for :tags, allow_destroy: true
  has_many_attached :images
  validates :required_time, numericality: { only_integer: true }
  validates :title, :explain, :date, :required_time, :meeting_time, presence: true
  validates :title, length: { maximum: 20 }
  validates :explain, length: { maximum: 100 }
  validates :images, limit: { min: 1, max: 8 },
                     content_type: { in: %w[image/jpeg image/gif image/png image/jpg],
                                     message: "形式はjpeg, jpg, gif, pngのみ有効です。" },
                     size: { less_than: 5.megabytes,
                             message: "ファイルは5MB以下である必要があります。" }
  validate :date_must_be_future, on: [:create, :update]
  validate :time_must_be_future, on: [:create, :update]

  def recruit_tags_create(tags_name)
    tag_list = tags_name.strip.split(/[[:blank:]]+/).select(&:present?)
    return false if tag_list.length > 3

    tags_relation = RecruitTag.where(recruit_id: id)
    tags_relation.where.not(tag_id: tags.last.id).destroy_all if tag_list.length == 1
    if tag_list.length.between?(2, 3)
      transaction do
        tags.destroy_all
        tag_list.each do |tag|
          tag = Tag.find_or_create_by(name: tag)
          tags << tag
        end
        Tag.find_by(name: tags_name).destroy
      end
    end
    true
  end

  def resize_image(image)
    metadata = image.blob.metadata
    size = [metadata[:width], metadata[:height]].min
    image.variant(gravity: :center, resize: "#{size}x#{size}", crop: "#{size}x#{size}+0+0")
  end

  def image_remain?(delete_num, image_params)
    remain_image = images.count - delete_num.length
    if remain_image.positive?
      true
    elsif remain_image.zero?
      if image_params.present?
        true
      else
        false
      end
    end
  end

  def image_delete(delete_num)
    delete_num.each do |num|
      images[num.to_i].purge_later
    end
  end

  def soft_delete
    update(deleted_at: Time.current)
  end

  def restore
    update(deleted_at: nil)
  end

  private

  def date_must_be_future
    errors.add(:date, 'は本日以降を選択してください') if date.nil? || date < Time.zone.today
  end

  def time_must_be_future
    errors.add(:meeting_time, 'は現在の時刻以降を指定してください') if meeting_time.nil? || ((I18n.l meeting_time) < (I18n.l Time.current) && date == Time.zone.today)
  end
end
