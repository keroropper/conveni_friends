FactoryBot.define do
  factory :recruit do
    title { 'title' }
    explain { 'explain' }
    date { Date.tomorrow }
    meeting_time { 1.hour.from_now }
    required_time { 30 }
    option { 'option' }
    user { association :user }

    trait :with_images do
      after(:build) do |recruit|
        recruit.images.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'kitten.jpg')), filename: 'kitten.jpg', content_type: 'image/jpg')
      end
    end
  end
end
