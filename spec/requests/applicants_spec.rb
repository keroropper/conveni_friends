require 'rails_helper'

RSpec.describe "Applicants", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other) { FactoryBot.create(:user) }
  let(:recruit) { FactoryBot.create(:recruit, user: other) }
  before do
    sign_in(user)
  end

  it '応募できること' do
    expect do
      post recruit_applicants_path(recruit), xhr: true
    end.to change { recruit.applicants.count }.by(1)
  end

  it '応募のキャンセルができること' do
    post recruit_applicants_path(recruit), xhr: true
    applicant = Applicant.find_by(user_id: user.id, recruit_id: recruit.id)
    expect do
      delete recruit_applicant_path(recruit, applicant), xhr: true
    end.to change { recruit.applicants.count }.by(-1)
  end

  it '応募すると通知が増えること' do
    expect do
      post recruit_applicants_path(recruit), xhr: true
    end.to change { recruit.user.notifications.count }.by(1)
  end
end
