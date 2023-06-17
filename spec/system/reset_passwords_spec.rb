require 'rails_helper'

RSpec.describe "ResetPasswords", type: :system, js: true do
  before do
    allow_any_instance_of(ActionController::Base).to receive(:allow_forgery_protection).and_return(true)
  end
  let(:user) { FactoryBot.create(:user, email: "test@example.com", password: 'before') }

  it 'メールアドレスを送信するとポップアップメニューが表示される' do
    send_mail(user)
    expect(page).to have_content('test@example.comにパスワード再設定のメールを送信しました')
  end

  it 'ポップアップのOKボタンを押すとログインページが表示される' do
    send_mail(user)
    click_button 'OK'
    expect(current_path).to eq '/users/sign_in'
  end

  it 'ユーザーはパスワードを更新できる' do
    send_mail(user)
    sleep 1
    mail = ActionMailer::Base.deliveries.last
    mail_body = mail.body.encoded
    reset_url = URI.extract(mail_body)[0].match(%r{/users/password/edit\?reset_password_token=.+})
    visit reset_url
    expect(current_path).to eq '/users/password/edit'

    # 登録に失敗する場合
    # 何も入力せずにSubmitボタンをクリック
    click_button 'パスワードを変更する'
    expect(page).to have_content "パスワードを入力してください"

    # 確認用のフィールドと値が一致しない場合
    fill_in "user_password",	with: "1234567"
    fill_in "user_password_confirmation",	with: "12345678"
    click_button 'パスワードを変更する'
    expect(page).to have_content "パスワード（確認）とパスワードの入力が一致しません"

    # パスワードの長さが足りない場合
    fill_in "user_password",	with: "1234"
    fill_in "user_password_confirmation",	with: "1234"
    click_button 'パスワードを変更する'
    expect(page).to have_content "パスワードは6文字以上で入力してください"

    # 登録に成功する場合
    fill_in "user_password",	with: "password"
    fill_in "user_password_confirmation",	with: "password"
    click_button 'パスワードを変更する'
    expect(current_path).to eq '/users/sign_in'

    # 変更したパスワードでログインができる
    fill_in "user_email", with: "test@example.com"
    fill_in "user_password",	with: "password"
    click_button 'ログイン'
    expect(page).to have_current_path(authenticated_root_path)
  end

  def send_mail(user)
    visit new_user_password_path
    fill_in "user_email",	with: user.email
    click_button '送信'
  end
end
