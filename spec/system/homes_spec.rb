require 'rails_helper'

RSpec.describe "Homes", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other) { FactoryBot.create(:user) }
  let!(:recruit) { FactoryBot.create_list(:recruit, 5) }
  before do
    sign_in(user)
    visit root_path
  end

  describe "secrets#index" do
    it '画面に投稿が表示されている' do
      expect(page).to have_selector('.list-rst__body', count: 5)
      expect(page).to have_css('strong', text: '5')
    end

    it '未読の通知の数がヘッダーに表示されていること' do
      create_list(:notification, 5, sender_id: other.id, receiver_id: user.id, category: 'relation', read: false)
      visit root_path
      expect(page).to have_css('.unread-notification-count span', text: user.notifications.count.to_s)
    end
  end
end
