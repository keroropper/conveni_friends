require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other) { FactoryBot.create(:user) }
  let(:recruit) { FactoryBot.create(:recruit, user: other) }
  before do
    sign_in(user)
  end

  it 'いいねを非同期で送信できること' do
    expect do
      post recruit_favorites_path(recruit), xhr: true
    end.to change { recruit.favorites.count }.by(1)
  end

  it 'いいねを非同期で削除できること' do
    post recruit_favorites_path(recruit), xhr: true
    expect do
      delete recruit_favorite_path(recruit, recruit.favorites), xhr: true
    end.to change { recruit.favorites.count }.by(-1)
  end

  it 'いいねをすると通知が増えること' do
    expect do
      post recruit_favorites_path(recruit), xhr: true
    end.to change { recruit.user.notifications.count }.by(1)
  end
end
