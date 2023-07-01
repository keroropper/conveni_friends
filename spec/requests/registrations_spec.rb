require 'rails_helper'

RSpec.describe "Registrations" do
  describe 'アカウント登録' do
    before do
      ActionMailer::Base.deliveries.clear
    end

    it 'アカウント登録ができること' do
      user_attributes = FactoryBot.attributes_for(:user, :unconfirmed_user)
      expect do
        post user_registration_path, params: { user: user_attributes }
      end.to change { User.count }.by(1)
    end

    it 'アカウント登録後は送信確認ページへ遷移すること' do
      sign_up
      follow_redirect!
      expect(request.fullpath).to include('/users/confirmation/info')
    end

    it 'アカウント登録後、メールが送信されること' do
      expect do
        sign_up
      end.to change { ActionMailer::Base.deliveries.size }.by(1)
    end

    it 'メールの再送信ができ、再送信後は送信確認ページへ遷移すること' do
      sign_up
      mail_count = ActionMailer::Base.deliveries.count
      post user_confirmation_path, params: { user: { email: User.last.email } }
      expect(ActionMailer::Base.deliveries.count).to eq(mail_count + 1)
      follow_redirect!
      expect(request.fullpath).to include('/users/confirmation/info')
    end
  end

  def sign_up
    user_attributes = FactoryBot.attributes_for(:user, :unconfirmed_user)
    post user_registration_path, params: { user: user_attributes }
  end
end
