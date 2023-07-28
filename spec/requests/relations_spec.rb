require 'rails_helper'

RSpec.describe "Relations", type: :request do
  let(:user) { create(:user) }
  let(:other) { create(:user) }
  let(:recruit) { create(:recruit, user:) }
  before do
    Applicant.create(user_id: other.id, recruit_id: recruit.id)
    sign_in user
  end

  it 'ユーザーは相手を承認できること' do
    initial_count = user.followings.count
    post user_relations_path(other, recruit_id: recruit.id)
    expect(user.reload.followings.count).to eq(initial_count + 1)
    expect(response).to redirect_to user_relations_path(user)
  end

  it '承認した後、その投稿に応募していた他のユーザーの応募情報が削除されること' do
    other2 = FactoryBot.create(:user)
    Applicant.create(user_id: other2.id, recruit_id: recruit.id)
    post user_relations_path(other, recruit_id: recruit.id)
    applicant = Applicant.where(recruit_id: recruit.id)
    expect(applicant.map(&:user_id)).to_not include(other2.id)
  end
end
