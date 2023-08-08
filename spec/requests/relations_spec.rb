require 'rails_helper'

RSpec.describe "Relations", type: :request do
  let(:user) { create(:user) }
  let(:other) { create(:user) }
  let(:recruit) { create(:recruit, user:, title: '論理削除') }
  before do
    Applicant.create(user_id: other.id, recruit_id: recruit.id)
    sign_in user
  end

  it 'ユーザーは相手を承認できること' do
    expect do
      post user_relations_path(other, recruit_id: recruit.id)
    end.to change { user.followings.count }.by(1)
    expect(response).to redirect_to user_relations_path(user)
  end

  it '承認した後、その投稿に応募していた他のユーザーの応募情報が削除されること' do
    other2 = FactoryBot.create(:user)
    Applicant.create(user_id: other2.id, recruit_id: recruit.id)
    post user_relations_path(other, recruit_id: recruit.id)
    applicant = Applicant.where(recruit_id: recruit.id)
    expect(applicant.map(&:user_id)).to_not include(other2.id)
  end

  it '違うユーザーのマッチング画面へ遷移しようとするとルートへリダイレクトすること' do
    get user_relations_path(other)
    expect(response).to redirect_to root_path
  end

  it '相手を承認すると通知が増えること' do
    expect do
      post user_relations_path(other, recruit_id: recruit.id)
    end.to change { other.notifications.count }.by(1)
  end

  it '相手を承認すると、対象の投稿が論理削除されること' do
    get root_path
    expect(response.body).to include('論理削除')
    expect(recruit.deleted_at).to be_nil
    expect do
      post user_relations_path(other, recruit_id: recruit.id)
    end.to change { recruit.reload.deleted_at }.from(nil).to(a_value)
    get root_path
    expect(response.body).to_not include('論理削除')
  end
end
