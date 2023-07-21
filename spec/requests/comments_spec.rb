require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:recruit) { FactoryBot.create(:recruit, user:) }
  before do
    sign_in(user)
  end

  it 'コメントを非同期で送信できること' do
    expect do
      post recruit_comments_path(recruit), params: { comment: { text: 'コメント', recruit_id: recruit.id } }, xhr: true
    end.to change { recruit.comments.count }.by(1)
  end
end