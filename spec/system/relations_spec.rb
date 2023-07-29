require 'rails_helper'

RSpec.describe "Relations", type: :system, js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other) { FactoryBot.create(:user) }
  let!(:recruit) { FactoryBot.create(:recruit, user:) }
  let!(:relation) { FactoryBot.create(:relation, follower_id: other.id, followed_id: user.id, recruit_id: recruit.id) }
  let!(:chat_room) { create(:chat_room) }

  before do
    Member.create(user_id: user.id, chat_room_id: chat_room.id)
    Member.create(user_id: other.id, chat_room_id: chat_room.id)
    sign_in user
    visit user_relations_path(user)
  end

  it 'マッチングした相手が表示されていること' do
    expect(page).to have_content(other.name)
  end

  it 'マッチングユーザーをクリックすると、対象のrecruitが画面に表示されること' do
    within '.target-users-list' do
      find('a').click
    end
    expect(page).to have_content(recruit.title)
  end
end
