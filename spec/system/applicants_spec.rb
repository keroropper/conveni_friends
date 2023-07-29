require 'rails_helper'

RSpec.describe "Applicants", type: :system do
  before do
    create_applicants
  end
  let!(:user) { User.first }
  let!(:recruit) { Recruit.first }

  it '応募者一覧が表示でき、その応募者の詳細ページには承認ボタンがあること',focus: true do
    sign_in(user)
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
end
