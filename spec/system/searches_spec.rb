require 'rails_helper'

RSpec.describe "Searches", type: :system do
  let!(:user) { FactoryBot.create(:user, age: 25, score: 5) }
  let!(:other) { FactoryBot.create(:user, age: 40, score: 4) }
  let!(:target) do
    FactoryBot.create(:recruit,
                      user:,
                      title: 'title1',
                      date: Date.tomorrow,
                      meeting_time: 2.hours.from_now,
                      required_time: '30',
                      address: '東京都',
                      tag_names: ['tag1'])
  end
  let!(:recruit) do
    FactoryBot.create(:recruit,
                      user:,
                      title: 'title2',
                      date: 3.days.from_now,
                      meeting_time: 4.hours.from_now,
                      required_time: '90',
                      address: '埼玉県',
                      tag_names: ['tag2'])
  end
  let!(:other_users_recruit) do
    FactoryBot.create(:recruit,
                      user: other,
                      title: 'title3')
  end

  before do
    sign_in user
    visit root_path
  end

  it 'タイトルで検索できること' do
    fill_in "keyword",	with: "title1"
    click_button '絞り込む'
    expect(page).to have_css('.list-rst__title', text: 'title1')
    expect(page).to_not have_css('.list-rst__title', text: 'title2')
  end
  it 'エリアで検索できること' do
    fill_in "address",	with: "東京都"
    click_button '絞り込む'
    expect(page).to have_css('.info__place__wrap', text: '東京都')
    expect(page).to_not have_css('.info__place__wrap', text: '埼玉県')
  end
  it 'タグで検索できること' do
    fill_in "name",	with: "tag1"
    click_button '絞り込む'
    expect(page).to have_css('.list-rst__tags', text: 'tag1')
    expect(page).to_not have_css('.list-rst__tags', text: 'tag2')
  end
  it '日付で検索できること' do
    date = Date.tomorrow
    other_date = 3.days.from_now
    fill_in "date",	with: I18n.l(date).to_s
    click_button '絞り込む'
    expect(page).to have_css('.info__date__wrap', text: I18n.l(date).to_s)
    expect(page).to_not have_css('.info__date__wrap', text: I18n.l(other_date).to_s)
  end
  it '時刻で検索できること' do
    target_time = I18n.l(2.hours.from_now)
    other_time = I18n.l(4.hours.from_now)
    fill_in "meeting_time",	with: target_time.to_s
    click_button '絞り込む'
    sleep 1
    expect(page).to have_css('.info__time__wrap', text: target_time.to_s)
    expect(page).to_not have_css('.info__time__wrap', text: other_time.to_s)
  end
  it '所要時間で検索できること' do
    select '30分',	from: "required_time"
    click_button '絞り込む'
    expect(page).to have_css('.info__required__wrap', text: '30分')
    expect(page).to_not have_css('.info__required__wrap', text: '1時間30分')
  end
  it '年齢で検索できること' do
    select '20歳', from: 'start_age'
    select '30歳', from: 'end_age'
    click_button '絞り込む'
    expect(page).to have_css('.list-rst__title', text: 'title1')
    expect(page).to have_css('.list-rst__title', text: 'title2')
    expect(page).to_not have_css('.list-rst__title', text: 'title3')
  end
  it 'スコアで検索できること', js: true do
    find('img[title="gorgeous"]').click
    click_button '絞り込む'
    expect(page).to have_css('.list-rst__title', text: 'title1')
    expect(page).to have_css('.list-rst__title', text: 'title2')
    expect(page).to_not have_css('.list-rst__title', text: 'title3')
  end
  it 'クリアボタンで、条件をリセットできること', js: true do
    fill_in "keyword",	with: "title1"
    fill_in "address",	with: "東京都"
    fill_in "name",	with: "tag1"
    find('#meeting_time').click
    select '30分',	from: "required_time"
    select '20歳', from: 'start_age'
    select '30歳', from: 'end_age'
    find('.search-clear-btn').click
    aggregate_failures do
      expect(find('#keyword').value).to be_empty
      expect(find('#address').value).to be_empty
      expect(find('#name').value).to be_empty
      expect(find('#date').value).to be_empty
      expect(find('#meeting_time').value).to be_empty
      expect(find('#required_time').value).to be_empty
      expect(find('#start_age').value).to be_empty
      expect(find('#end_age').value).to be_empty
    end
  end
end
