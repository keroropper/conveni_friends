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

    it 'ヘッダーの"アカウント"をクリックするとポップアップメニューが表示されること', js: true do
      expect(page).to_not have_css('.header-user-menu__wrapper')
      find('.header__user-menu').click
      expect(page).to have_css('.header-user-menu__wrapper')

      # ユーザー詳細ページへのリンク
      find('.header-user__info').click
      expect(page).to have_content(user.name)

      # 投稿一覧へのリンク
      visit root_path
      find('.header__user-menu').click
      find('.user-recruits-link').click
      expect(page).to have_content('投稿した募集')

      # いいねした募集一覧へのリンク
      visit root_path
      find('.header__user-menu').click
      find('.user-favorites-link').click
      expect(page).to have_content('いいね！した募集')

      # 応募した投稿一覧へのリンク
      visit root_path
      find('.header__user-menu').click
      find('.user-applicants-link').click
      expect(page).to have_content('応募した投稿一覧')

      # チャットへのリンク
      visit root_path
      find('.header__user-menu').click
      find('.user-relations-link').click
      expect(page).to have_content('チャット')
    end

    it 'ページネーションが表示されていること' do
      create_list(:recruit, 7)
      visit root_path
      expect(page).to have_css('.pagination')

      click_link '2'
      expect(page).to have_current_path(root_path(page: 2))
    end

    it '簡単ログイン機能', js: true do
      find('.header__user-menu').click
      find('.user-logout-link').click
      get root_path
      expect(page).to have_content('簡単ログイン')
      find('.header__easy-sign-in>a').click
      expect(page).to have_content('アカウント')
    end
  end
end
