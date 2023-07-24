require 'rails_helper'

RSpec.describe "Relations", type: :system, js: true do
  let!(:user) { FactoryBot.create(:user) }
  let!(:other) { FactoryBot.create(:user) }
  let!(:recruit) { FactoryBot.create(:recruit, user:) }
  let!(:relation) { FactoryBot.create(:relation, follower_id: other.id, followed_id: user.id, recruit_id: recruit.id) }

  before do 
    sign_in user
    visit user_relations_path(user)
  end

  it 'マッチングした相手が表示されていること' do
    expect(page).to have_content(other.name)
  end

  it 'マッチングユーザーをクリックすると、対象のrecruitが画面に表示されること' do
    find('.target-user-info').click
    expect(page).to have_content(recruit.title)
  end
end
