require 'rails_helper'

RSpec.describe "ChatMessages", type: :system, js: true do
  describe 'Create Message' do
    let!(:user) { create(:user) }
    let!(:other) { create(:user) }
    let!(:recruit) { create(:recruit, user:) }
    let!(:chat_room) { create(:chat_room) }
    let!(:relation) { create(:relation, followed_id: user.id, follower_id: other.id, recruit_id: recruit.id) }
    before do
      Member.create(user_id: user.id, chat_room_id: chat_room.id)
      Member.create(user_id: other.id, chat_room_id: chat_room.id)
      sign_in user
      visit user_relations_path(user.id)
    end

    it '対象のユーザーをクリックするとチャットが表示されること' do
      ChatMessage.create(user_id: other.id, chat_room_id: chat_room.id, content: 'テストコメント')
      within '.target-users-list' do
        find('a').click
        sleep 1
      end
      expect(page).to have_content('テストコメント')
    end

    it 'メッセージを送信するとメッセージが画面に表示されること' do
      within '.target-users-list' do
        find('a').click
      end
      fill_in 'chat_room_content', with: '送信コメント'
      click_on '送信'
      expect(page).to have_content('送信コメント')
    end

    it 'メッセージを送信するとメッセージが相手の画面に表示されること' do

      using_session :user1 do
        sign_in user
        visit user_relations_path(user.id)
        within '.target-users-list' do
          find('a').click
          sleep 1
        end
      end
      using_session :user2 do
        sign_in other
        visit user_relations_path(other.id)
        within '.target-users-list' do
          find('a').click
          sleep 1
        end
      end

      using_session :user1 do
        fill_in 'chat_room_content', with: '相手にコメント'
        click_on '送信'
      end

      using_session :user2 do
        expect(page).to have_content('相手にコメント')
      end
    end

    it 'メッセージを送信すると通知が増えること' do
      within '.target-users-list' do
        find('.target-user-info').click
      end
      fill_in 'chat_room_content', with: '送信コメント'
      click_on '送信'
      expect(other.notifications.count).to eq 1
    end
  end
end
