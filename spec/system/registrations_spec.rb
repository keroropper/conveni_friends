require 'rails_helper'
require 'uri'

RSpec.describe "Registrations", type: :system do
  include ActiveJob::TestHelper

  it "ユーザーは新規登録に成功する", focus: true do
    perform_enqueued_jobs do
      expect do
        sign_up
      end.to change { User.count }.by(1)

      expect(page).to have_content("メールが送信されました。")
      expect(current_path).to eq users_confirmation_info_path
    end

    mail = ActionMailer::Base.deliveries.last

    aggregate_failures do
      expect(mail.to).to eq ["test@example.com"]
      expect(mail.from).to eq ["sample@example.com"]
      expect(mail.subject).to eq "メールアドレス確認メール"
      expect(mail.body).to match "tester様"
      expect(mail.body).to match "メールアドレスの確認"
    end

    mail_body = mail.body.encoded
    confirmed_url = URI.extract(mail_body)[0]
    visit confirmed_url
    expect(current_path).to eq authenticated_root_path
    expect(User.last.activated).to eq true
  end

  it "ユーザー登録後、メール再送信ページに登録したアドレスが入力されている" do
    sign_up
    click_link "メールを再送信する"
    expect(current_path).to eq new_user_confirmation_path
    expect(page).to have_field("user_email", with: "test@example.com")
  end

  def sign_up
    visit new_user_registration_path
    fill_in "user_name",	with: "tester"
    fill_in "user_age",	with: "20"
    select "男性", from: "user_gender"
    fill_in "user_email",	with: "test@example.com"
    fill_in "user_password",	with: "password"
    fill_in "user_password_confirmation",	with: "password"
    click_button "登録"
  end
end
