class Recruit < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  validates :required_time, numericality: { only_integer: true }
  validates :title, :explain, :date, :required_time, :meeting_time, presence: true
  validates :title, length: { maximum: 20 }
  validates :explain, :option, length: { maximum: 100 }
  validates :images, attached: true,
                     content_type: { in: %w[image/jpeg image/gif image/png],
                                     message: "jpeg, gif, pngのみ有効です。" },
                     size: { less_than: 5.megabytes,
                             message: "ファイルは5MB以下である必要があります。" }
  validate :date_must_be_future, on: :create
  validate :time_must_be_future, on: :create

  def date_must_be_future
    errors.add(:date, 'は本日以降を選択してください') if date.nil? || date < Time.zone.today
  end

  def time_must_be_future
    errors.add(:meeting_time, 'は現在の時刻以降を指定してください') if meeting_time.nil? || (meeting_time.strftime("%H:%M:%S") < Time.current.strftime("%H:%M:%S") && date == Time.zone.today)
  end
end
