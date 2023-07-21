FactoryBot.define do
  factory :applicant do
  end
end

def create_applicants
  5.times do
    FactoryBot.create(:user)
  end

  recruit = FactoryBot.create(:recruit, user: User.first)

  User.all[1..].each do |user|
    FactoryBot.create(:applicant, user_id: user.id, recruit_id: recruit.id)
  end
end
