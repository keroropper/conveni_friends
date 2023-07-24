FactoryBot.define do
  factory :relation do
    follower_id { association(:user).id }
    followed_id { association(:user).id }
    recruit
  end
end

def create_relations 
  5.times do
    FactoryBot.create(:user)
  end

end
