require "rails_helper"

RSpec.describe "UserMailer", type: :mailer do
  before do
    ActionMailer::Base.deliveries.clear
  end

  let!(:user) { FactoryBot.create(:user, :unconfirmed_user) }
  let(:mail) { ActionMailer::Base.deliveries.first }

  it '確認メールをユーザーのメールアドレスに送ること' do
    expect(mail.to).to eq [user.email]
  end

  it "正しい件名で送信すること" do
    expect(mail.subject).to eq "メールアドレス確認メール"
  end

  it "ユーザー名で挨拶すること" do
    expect(mail.body).to match(/#{user.name}様/)
  end

  it "認証リンクが添付されていること" do
    expect(mail.body).to have_link("メールアドレスの確認", href: %r{/users/confirmation\?confirmation_token=.+})
  end
end
