require 'rails_helper'

RSpec.describe "Homes", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:recruit) { FactoryBot.create_list(:recruit, 5) }
  before do
    sign_in(user)
    visit root_path
  end

  describe "secrets#index", focus: true do
    it '画面に投稿が表示されている' do
      expect(page).to have_selector('.list-rst__body', count: 5)
      expect(page).to have_css('strong', text: '5')
    end
  end
end
