require 'rails_helper'

RSpec.describe "Notifications", type: :system do
  let(:user) { create(:user) }
  let(:other) { create(:user) }
  let(:recruit) { create(:recruit, user:) }
  before do
    category = %w[relation comment applicant chat_message favorite]
    category.each do |c|
      create(:notification, sender_id: other.id, receiver_id: user.id, recruit_id: recruit.id, category: c, read: false)
    end
    sign_in user
  end

  it '通知が画面に表示されていること' do
    visit user_notifications_path(user)
    aggregate_failures do
      expect(page).to have_content("#{other.name}さんとマッチしました。")
      expect(page).to have_content("#{other.name}さんからメッセージが届きました。")
      expect(page).to have_content("#{other.name}さんが「#{recruit.title}」にコメントしました。")
      expect(page).to have_content("#{other.name}さんが「#{recruit.title}」に応募しました。")
      expect(page).to have_content("#{other.name}さんが「#{recruit.title}」にいいねしました。")
    end
  end

  it 'ページネーションが表示されていること' do
    create_list(:notification, 30, sender_id: other.id, receiver_id: user.id, recruit_id: recruit.id, category: 'chat_message', read: false)
    visit user_notifications_path(user)
    expect(page).to have_css('.pagination')

    click_link '2'
    expect(page).to have_current_path(user_notifications_path(user, page: 2))
  end
end
