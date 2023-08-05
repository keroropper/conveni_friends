require 'rails_helper'

RSpec.describe "Recruit", type: :system, js: true do
  let(:user) { FactoryBot.create(:user) }
  let!(:recruit) { FactoryBot.create(:recruit, user:) }
  before do
    sign_in(user)
    visit edit_recruit_path(recruit)
  end

  it 'フィールドに保存データが表示されていること' do
    # # 画像
    images = find_all('img')
    expect(images.first['src']).to include(recruit.images[0].filename.to_s)
    # タグ
    tags_field = find('#recruit_tags')
    tags_name = recruit.tags.map(&:name)
    joined_tags = tags_name.join(' ')
    expect(tags_field.value).to eq(joined_tags)
    # タイトル
    title_field = find('#recruit_title')
    expect(title_field.value).to eq(recruit.title)
    # 概要
    explain_field = find('#recruit_explain')
    expect(explain_field.value).to eq(recruit.explain)
    # 日付
    date_field = find('#date')
    expect(date_field.value).to eq(I18n.l(recruit.date))
    # 集合時間
    meeting_time_field = find('#meeting_time')
    expect(meeting_time_field.value).to eq(recruit.meeting_time.strftime('%H:%M'))
    # 所要時間(セレクタはfindではなく直接渡す必要がある)
    expect(page).to have_select('recruit[required_time]', selected: "#{recruit.required_time}分")
  end

  it '値を更新できること' do
    # 画像削除
    delete_btn = find('.image-delete')
    delete_btn.click
    create_recruit(attach: true, file_name: '縦長.jpeg', tags: 'タグ1 タグ2 タグ3', title: "update", explain: "update", date: 5.days.from_now,
                   meeting_time: 1.hour.ago.strftime('%H'), required_time: "１時間", address: '')
    recruit.reload
    aggregate_failures do
      expect(page).to have_current_path(root_path)
      expect(recruit.images[0].filename.to_s).to eq('縦長.jpeg')
      recruit.tags.each_with_index do |tag, i|
        expect(tag.name).to eq("タグ#{i + 1}")
      end
      expect(recruit.title).to eq('update')
      expect(recruit.explain).to eq('update')
      expect(I18n.l(recruit.date)).to eq(I18n.l(Date.current + 5))
      expect(I18n.l(recruit.meeting_time)).to eq(I18n.l(1.hour.ago))
      expect(recruit.required_time).to eq(60)
    end
  end

  it 'updateが失敗した時のrender :edit画面で、入力していた情報が表示されていること' do
    # 画像削除
    delete_btn = find('.image-delete')
    delete_btn.click
    create_recruit(attach: false, tags: 'タグ1 タグ2 タグ3', title: "update", explain: "update", date: 5.days.from_now,
                   meeting_time: 1.hour.ago.strftime('%H'), required_time: "１時間", address: '')
    expect(page).to have_current_path("/recruits/#{recruit.id}")
    # # 画像
    images = find_all('img')
    expect(images.first['src']).to include(recruit.images[0].filename.to_s)
    # タグ
    tags_field = find('#recruit_tags')
    expect(tags_field.value).to eq('タグ1 タグ2 タグ3')
    # タイトル
    title_field = find('#recruit_title')
    expect(title_field.value).to eq('update')
    # 概要
    explain_field = find('#recruit_explain')
    expect(explain_field.value).to eq('update')
    # 日付
    date_field = find('#date')
    expect(date_field.value).to eq(I18n.l(Date.current + 5))
    # 集合時間
    meeting_time_field = find('#meeting_time')
    expect(meeting_time_field.value).to eq(I18n.l(1.hour.ago))
    # 所要時間(セレクタはfindではなく直接渡す必要がある)
    expect(page).to have_select('recruit[required_time]', selected: "１時間")
  end
end
