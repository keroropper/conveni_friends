FactoryBot.define do
  factory :recruit do
    title { 'title' }
    explain { 'explain' }
    date { Date.tomorrow }
    meeting_time { 1.hour.from_now }
    required_time { 30 }
    option { 'option' }
    user { association :user }

    transient do
      tag_names { ["Tag1", "Tag2", "Tag3"] }
    end

    after(:build) do |recruit, evaluator|
      tag_attributes = evaluator.tag_names.map { |name| { name: } }
      recruit.tags_attributes = tag_attributes
    end

    after(:build) do |recruit|
      recruit.images.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'kitten.jpg')), filename: 'kitten.jpg', content_type: 'image/jpg')
    end
  end
end
