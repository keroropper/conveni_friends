require 'rails_helper'

RSpec.describe "Recruits", type: :system, js: true do
  let(:user) { FactoryBot.create(:user) }
  let!(:recruit) { FactoryBot.create(:recruit, user:) }
  before do
    recruit.images.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', '縦長.jpeg')), filename: '縦長.jpeg', content_type: 'image/jpeg')
    sign_in(user)
    visit recruit_path(recruit)
  end

  it '画像クリックで画像がスライドすること', focus: true do
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
end
