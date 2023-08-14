require 'rails_helper'

RSpec.describe Recruit, type: :model do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :explain }
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :required_time }
  it { is_expected.to validate_presence_of :meeting_time }

  it { is_expected.to validate_length_of(:title).is_at_most(20) }
  it { is_expected.to validate_length_of(:explain).is_at_most(300) }

  it { is_expected.to validate_numericality_of(:required_time).only_integer }

  describe 'Recruit :images' do
    let(:user) { create(:user) }
    let(:recruit) { FactoryBot.build(:recruit, user:) }
    it '画像がアタッチされていること' do
      recruit.save
      expect(recruit.images.attached?).to be true
    end

    context "images属性 presence, content type, and sizeバリデーション検証" do
      it "presence" do
        recruit = Recruit.new(FactoryBot.attributes_for(:recruit, user:))
        expect(recruit).not_to be_valid
        expect(recruit.errors.full_messages).to include("画像の数が許容範囲外です")
      end

      it "type" do
        invalid_type_file = Rails.root.join('spec', 'fixtures', 'files', 'SVGアイコン.svg')
        recruit.images.attach(io: File.open(invalid_type_file), filename: 'SVGアイコン', content_type: 'image/svg')
        recruit.valid?
        expect(recruit).not_to be_valid
        expect(recruit.errors.full_messages).to eq(["画像形式はjpeg, jpg, gif, pngのみ有効です。"])
      end

      it "size" do
        over_size_file = Rails.root.join('spec', 'fixtures', 'files', '6MB.jpg')
        recruit.images.attach(io: File.open(over_size_file), filename: '6MB.jpg', content_type: 'image/jpg')
        recruit.valid?
        expect(recruit).not_to be_valid
        expect(recruit.errors.full_messages).to eq(["画像ファイルは5MB以下である必要があります。"])
      end
    end
  end

  describe '#date_must_be_future' do
    let(:user) { FactoryBot.create(:user) }

    context "日付が今日以降の場合" do
      let(:recruit) { build(:recruit, date: Date.tomorrow, user:) }
      it 'バリデーションをパスすること' do
        recruit.validate
        expect(recruit.errors[:date]).to be_empty
      end
    end

    context "日付が過去の場合" do
      let(:recruit) { build(:recruit, date: Date.yesterday, user:) }
      it 'バリデーションエラーが発生すること' do
        recruit.validate
        expect(recruit.errors[:date]).to include('は本日以降を選択してください')
      end
    end
  end

  it 'save with tags' do
    user = FactoryBot.create(:user)
    recruit = FactoryBot.build(:recruit, user:)
    recruit.save
    expect(recruit).to be_valid
  end
end
