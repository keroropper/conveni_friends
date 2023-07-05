class Recruit < ApplicationRecord
  belongs_to :user
  has_many :recruit_tags, dependent: :destroy
  has_many :tags, through: :recruit_tags
  accepts_nested_attributes_for :tags, allow_destroy: true
  has_many_attached :images
  validates :required_time, numericality: { only_integer: true }
  validates :title, :explain, :date, :required_time, :meeting_time, presence: true
  validates :title, length: { maximum: 20 }
  validates :explain, :option, length: { maximum: 100 }
  validates :images, limit: { min: 1, max: 4 },
                     content_type: { in: %w[image/jpeg image/gif image/png image/jpg],
                                     message: "形式はjpeg, jpg, gif, pngのみ有効です。" },
                     size: { less_than: 5.megabytes,
                             message: "ファイルは5MB以下である必要があります。" }
  validate :date_must_be_future, on: :create
  validate :time_must_be_future, on: :create

  def recruit_tags_create(tags_name)
    tag_list = tags_name.strip.split(/[[:blank:]]+/).select(&:present?)
    return false if tag_list.length > 3

    if tag_list.length.between?(2, 3)
      tag_list.each do |tag|
        tag = Tag.find_or_create_by(name: tag)
        tags << tag
      end
      tags.find_by(name: tags_name).destroy if tag_list.length > 1 || Tag.where(name: tags_name).count == 2
    end
    true
  end

  private

  def date_must_be_future
    errors.add(:date, 'は本日以降を選択してください') if date.nil? || date < Time.zone.today
  end

  def time_must_be_future
    errors.add(:meeting_time, 'は現在の時刻以降を指定してください') if meeting_time.nil? || (meeting_time.strftime("%H:%M:%S") < Time.current.strftime("%H:%M:%S") && date == Time.zone.today)
  end
end
