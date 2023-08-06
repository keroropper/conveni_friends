require 'rails_helper'

RSpec.describe "Applicants", type: :system do
  before do
    create_applicants
  end
  let!(:user) { User.first }
  let!(:recruit) { Recruit.first }

  it '応募者一覧が表示でき、その応募者の詳細ページには承認ボタンがあること' do
    sign_in user
    visit recruit_applicants_index_path(recruit)
    User.all[1..].each do |user|
      expect(page).to have_content(user.name)
    end
    visit user_path(User.all[1])
    expect(page).to have_content('承認する')

    # 応募者でないユーザーページには承認ボタンがないこと
    not_applicant_user = FactoryBot.create(:user)
    visit user_path(not_applicant_user)
    expect(page).to_not have_content('承認する')

    # 自身のユーザーページには承認ボタンがないこと
    visit user_path(user)
    expect(page).to_not have_content('承認する')
  end

  describe 'ページネーション' do
    before do
      sign_in user
    end
    context "#recruit_applicants_index" do
      it 'ページネーションが表示されていること' do
        create_list(:user, 13)
        (6..18).each do |i|
          Applicant.create(user_id: i, recruit_id: recruit.id)
        end
        visit recruit_applicants_index_path(recruit)
        expect(page).to have_css('.pagination')
      end
    end
    context "#user_applicants_index" do
      it 'ページネーションが表示されていること' do
        create_list(:recruit, 12)
        recruits = Recruit.all
        (1..12).each do |i|
          Applicant.create(user_id: user.id, recruit_id: recruits[i].id)
        end
        visit user_applicants_index_path(user)
        expect(page).to have_css('.pagination')

        click_link '2'
        expect(page).to have_current_path(user_applicants_index_path(user, page: 2))
      end
    end
  end
end
