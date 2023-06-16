require 'rails_helper'

RSpec.describe "Sessions" do
  it "ログイン、ログアウトができること" do
    user = User.create!(name: 'tester', age: 20, email: "user@example.org", password: "very-secret")
    user.confirm

    sign_in user
    get authenticated_root_path
    expect(controller.current_user).to eq(user)

    sign_out user
    get authenticated_root_path
    expect(request.fullpath).to eq '/'
    expect(controller.current_user).to be_nil
  end
end
