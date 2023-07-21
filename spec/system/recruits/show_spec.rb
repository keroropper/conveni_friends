require 'rails_helper'

RSpec.describe "Recruits", type: :system, js: true do
  let(:user) { FactoryBot.create(:user) }
  let!(:recruit) { FactoryBot.create(:recruit, user:) }
  before do
    recruit.images.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', '縦長.jpeg')), filename: '縦長.jpeg', content_type: 'image/jpeg')
    sign_in(user)
    visit recruit_path(recruit)
  end

  it '画像クリックで画像がスライドすること' do
    side_images = find_all('.show-recruit__image.side-image')
    side_images[1].click
    image_wrap = find('.show-recruit__image.main-image')
    expect(image_wrap).to have_css('img', id: 'show-image-2', style: 'left: 592px; transform: translateX(-592px);')
  end

  it '矢印クリックで画像がスライドすること' do
    right = find('.right-arrow')
    right.click
    image_wrap = find('.show-recruit__image.main-image')
    expect(image_wrap).to have_css('img', id: 'show-image-2', style: 'left: 592px; transform: translateX(-592px);')
  end

  it 'コメントを投稿できること' do
    fill_in "comment_text",	with: "コメント"
    click_button '送信'
    expect(page).to have_css('.text-body', text: 'コメント')
  end

  it '空文字だとコメントを投稿できないこと' do
    fill_in "comment_text",	with: ""
    click_button '送信'
    expect(page).to_not have_css('.text-body', text: 'コメント')
  end

  it 'いいねをすると画面のカウントが変化すること' do
    expect(page).to have_css('.likes-count', text: '0')
    icon = find('.like-icon')
    icon.click
    expect(page).to have_css('.likes-count', text: '1')
  end

  it 'いいねを削除すると画面のカウントが変化すること' do
    icon = find('.like-icon')
    icon.click
    expect(page).to have_css('.likes-count', text: '1')
    icon.click
    expect(page).to have_css('.likes-count', text: '0')
  end

  describe 'Applicant' do
    let(:other) { create(:user) }
    let!(:others_recruit) { FactoryBot.create(:recruit, user: other) }
    before do
      visit recruit_path(others_recruit)
    end
    it '応募ボタンを押すとキャンセルボタンが表示されること(逆も)', focus: true do
      expect(page).to have_css('.create-actions')
      within('.create-actions') do
        input = find('input')
        expect(input.value).to eq('応募')
        input.click
      end
      expect(page).to have_css('.delete-actions')
      within('.delete-actions') do
        input = find('input')
        expect(input.value).to eq('キャンセル')
      end
    end
  end

  it 'いいねを削除すると画面のカウントが変化すること' do
    icon = find('.like-icon')
    icon.click
    expect(page).to have_css('.likes-count', text: '1')
    icon.click
    expect(page).to have_css('.likes-count', text: '0')
  end
end
