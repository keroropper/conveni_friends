require 'rails_helper'

RSpec.describe Recruit, type: :model do
  it { is_expected.to validate_presence_of :title }
  it { is_expected.to validate_presence_of :explain }
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to validate_presence_of :required_time }
  it { is_expected.to validate_presence_of :meeting_time }

  it { is_expected.to validate_length_of(:title).is_at_most(20) }
  it { is_expected.to validate_length_of(:explain).is_at_most(100) }
  it { is_expected.to validate_length_of(:option).is_at_most(100) }

  it { is_expected.to validate_numericality_of(:required_time).only_integer }

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
end
