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

    scenario 'googleMapにピンを立てると経度、緯度、住所が保存されること', focus: true do
      create_recruit(address: '秋葉原')
      expect(user.recruits.first.address).to eq "Akihabara, Taito City, Tokyo 110-0006, Japan"
      expect(user.recruits.first.latitude).to be_within(999.000001).of(35.702259)
      expect(user.recruits.first.latitude).to be_within(999.000001).of(139.774475)
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
      hour = 1.hour.ago.strftime('%H')
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

  def attach_image(name)
    page.execute_script('document.getElementById("img-file").style.display = "";')
    attach_file "img-file", Rails.root.join('spec', 'fixtures', 'files', name)
  end

  def create_recruit(attach: true, file_name: 'kitten.jpg', tags: '', title: "title", explain: "explain", date: Date.tomorrow,
                     meeting_time: "23", required_time: "30分", address: '', option: "option")
    attach_image(file_name) if attach
    fill_in "recruit_tags", with: tags
    fill_in "recruit_title",	with: title
    fill_in "recruit_explain",	with: explain

    # flatpickrでdateを選択
    find("#recruit_date").click
    within(".dayContainer") do
      find(".flatpickr-day[aria-label='#{date.strftime('%-m月 %-d, %Y')}']").click
    end
    # flatpickrでmeeting_timeを選択
    find("#recruit_meeting_time").click
    input_element = find(".numInput.flatpickr-hour")
    input_element.set(meeting_time)

    # googleMap
    mapInput = find('input[placeholder="Google マップを検索する"]')
    mapInput.set(address)
    mapSubmit = find('input[value="検索"]')
    mapSubmit.click if mapInput.value.present?


    select required_time,	from: "recruit_required_time"
    fill_in "recruit_option",	with: option
    click_button "募集"
  end
end
