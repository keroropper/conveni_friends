FactoryBot.define do
  factory :relation do
    follower_id { association(:user).id }
    followed_id { association(:user).id }
  end
end
