require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  it { is_expected.to validate_length_of(:name).is_at_most(20) }

  it { is_expected.to validate_presence_of :age }

  it 'accept the email addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to be_valid
    end
  end

  it 'is reject the email addresses' do
    valid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                         foo@bar_baz.com foo@bar+baz.com]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      expect(user).to_not be_valid
    end
  end

  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }

  it 'is save lower-case email' do
    user = FactoryBot.create(:user, email: "TEST@EXAMPLE.COM")
    expect(user.email).to eq "test@example.com"
  end

  it do
    is_expected.to validate_length_of(:password)
      .is_at_least(6)
      .is_at_most(20)
  end

  it { is_expected.to validate_presence_of(:password) }
end
