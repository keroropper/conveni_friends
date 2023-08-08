require 'rails_helper'

RSpec.describe "Users", type: :system, js: true do
  let!(:user) { FactoryBot.create(:user, :perfect_user) }
  before do
    sign_in(user)
  end

  describe 'Users#show' do
    it '編集ページへ遷移できること' do
      visit user_path(user)
      click_on 'プロフィールを編集する'
      expect(page).to have_current_path(edit_user_path(user))
    end
  end

  describe 'Users#edit' do
    it '自己紹介を編集できること' do
      visit edit_user_path(user)
      text = find('#user_introduce')
      text.set('')
      fill_in 'user_introduce', with: 'New text'
      submit_edit_btn
    end

    it '画像を編集できること' do
      visit edit_user_path(user)
      page.execute_script('document.getElementById("input-profile").style.display = "";')
      attach_file "input-profile", Rails.root.join('spec', 'fixtures', 'files', '縦長.jpeg')
      submit_edit_btn
      expect(user.reload.profile_photo.blob.filename.to_s).to eq '縦長.jpeg'
    end

    it '画像を削除できること', focus: true do
      visit edit_user_path(user)
      delete_btn = find('.image-delete')
      delete_btn.click
      submit_edit_btn
      expect(page).to_not have_selector('.profile-image>img')
      expect(user.reload.profile_photo.attached?).to be_falsey
    end
  end

  def submit_edit_btn
    edit_btn = find('#update-btn')
    edit_btn.click
  end
end
