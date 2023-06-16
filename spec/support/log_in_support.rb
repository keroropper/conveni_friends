module LogInSupport
  # def sign_in_as(user)
  #   visit new_user_registration_path
  #   fill_in "user_name",	with: "tester"
  #   fill_in "user_age",	with: "20"
  #   select "男性", from: "user_gender"
  #   fill_in "user_email",	with: "test@example.com"
  #   fill_in "user_password",	with: "password"
  #   fill_in "user_password_confirmation",	with: "password"
  #   click_button "登録"
  # end

  RSpec.configure do |config|
    config.include LogInSupport, type: :system
  end
end
