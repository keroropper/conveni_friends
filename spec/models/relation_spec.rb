require 'rails_helper'

RSpec.describe Relation, type: :model do
  describe 'Relation#create' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other) { FactoryBot.create(:user) }
    let!(:recruit) { FactoryBot.create(:recruit, user:) }
    let!(:relation) { FactoryBot.create(:relation, follower_id: user.id, followed_id: other.id, recruit_id: recruit.id) }

    it { is_expected.to validate_uniqueness_of(:followed_id).scoped_to(:follower_id) }
    it { is_expected.to validate_uniqueness_of(:follower_id).scoped_to(:followed_id) }

    it '自分自身はフォローできないこと' do
      invalid_relation = Relation.new(follower_id: user.id, followed_id: user.id, recruit_id: recruit.id)
      invalid_relation.valid?
      expect(invalid_relation.errors.full_messages).to eq(['自分自身をフォローすることはできません。'])
    end
  end
end
