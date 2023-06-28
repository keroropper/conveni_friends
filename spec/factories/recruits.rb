FactoryBot.define do
  factory :recruit do
    title { 'title' }
    explain { 'explain' }
    date { Date.tomorrow }
    meeting_time { '18:00' }
    required_time { 30 }
    option { 'option' }
    user { association :user }
  end
end
