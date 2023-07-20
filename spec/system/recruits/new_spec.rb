require 'rails_helper'

RSpec.describe "Recruits", type: :system, js: true do
  let(:user) { FactoryBot.create(:user) }
  before do
    sign_in(user)
    visit new_recruit_path
  end

  context "正常系" do
    scenario '投稿を作成する' do
      expect do
        create_recruit
      end.to change { user.recruits.count }.by(1)
      expect(page).to have_current_path(root_path)
    end

    scenario 'タグ付きの投稿を作成する' do
      expect do
        create_recruit(tags: 'tag1')
      end.to change { Tag.count }.by(1)
      expect(RecruitTag.count).to eq 1
    end

    scenario '同じ名前のタグは重複して保存されないこと' do
      expect do
        create_recruit(tags: 'tag tag')
      end.to change { Tag.count }.by(1)
      expect(Tag.where(name: 'tag').count).to eq 1
    end

    scenario '画像のプレビューができること' do
      attach_image('kitten.jpg')
      expect(page).to have_selector('img')
    end

    scenario '削除ボタンで画像のプレビューが削除できること' do
      attach_image('kitten.jpg')
      delete_btn = find('.image-delete')
      delete_btn.click
      expect(page).to_not have_selector('.image')
      expect(page).to have_field('img-file', with: '')
    end

    scenario '左の画像が削除されると右にあった画像は左に詰めること' do
      attach_image('kitten.jpg')
      attach_image('縦長.jpeg')
      first_delete_btn = all('.image-delete').first
      first_delete_btn.click
      expect(page).to have_selector('.image', count: 1)
      expect(page).to have_selector('.image', visible: true, count: 1)
    end

    scenario 'googleMapにピンを立てると経度、緯度、住所が保存されること',focus: true do
      create_recruit(address: '秋葉原')
      recruit = user.recruits.first
      expect(recruit.address).to eq "Taito,City,,Tokyo,110-0006,,Japan"
      expect(recruit.latitude).to be_within(999.000001).of(35.702259)
      expect(recruit.latitude).to be_within(999.000001).of(139.774475)
    end
  end

  context "異常系" do
    scenario '投稿に失敗した時、元の画面に戻ること' do
      click_button "募集"
      expect(page).to have_current_path('/recruits')
    end

    scenario '画像がないと投稿できないこと' do
      expect do
        create_recruit(attach: false)
      end.to_not(change { user.recruits.count })
      expect(page).to have_content('画像を選択してください')
    end

    scenario 'タグは3つまでであること' do
      expect do
        create_recruit(tags: 'tag1 tag2 tag3 tag4')
      end.to_not(change { Tag.count })
      expect(RecruitTag.count).to eq 0
      expect(page).to have_content('タグは3つまでしか登録できません')
    end

    scenario 'タイトルがないと投稿できないこと' do
      expect do
        create_recruit(title: nil)
      end.to_not(change { user.recruits.count })
      expect(page).to have_content('タイトルを入力してください')
    end

    scenario '概要がないと投稿できないこと' do
      expect do
        create_recruit(explain: nil)
      end.to_not(change { user.recruits.count })
      expect(page).to have_content('概要を入力してください')
    end

    scenario '日時が過去だと投稿できないこと' do
      expect do
        create_recruit(date: Date.yesterday)
      end.to_not(change { user.recruits.count })
      expect(page).to have_content('日付は本日以降を選択してください')
    end

    scenario '時間が過ぎていると投稿できないこと' do
      hour = 1.hour.ago
      expect do
        create_recruit(date: Time.zone.today, meeting_time: hour)
      end.to_not(change { user.recruits.count })
      expect(page).to have_content('集合時間は現在の時刻以降を指定してください')
    end

    scenario '所要時間を選択しないと投稿できないこと' do
      expect do
        create_recruit(required_time: '--')
      end.to_not(change { user.recruits.count })
      expect(page).to have_content('所要時間を選択してください')
    end
  end
end
