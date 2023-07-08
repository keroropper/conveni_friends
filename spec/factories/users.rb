FactoryBot.define do
  factory :user do
    name { 'ryoya' }
    age { 24 }
    gender { '男性' }
    sequence(:email) { Faker::Internet.unique.email }
    password { 'password' }
    confirmed_at { 1.day.ago }
    activated { true }
  end

  trait :unconfirmed_user do
    name { 'unconf' }
    age { 30 }
    gender { '男性' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
    confirmed_at { nil }
    activated { false }
  end

  trait :perfect_user do
    name { 'perfect' }
    age { 30 }
    gender { '男性' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
    confirmed_at { 1.day.ago }
    activated { true }
    introduce { '初めまして!私の名前はperfectです!' }
    after(:build) do |user|
      user.profile_photo.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'files', 'kitten.jpg')), filename: 'kitten.jpg', content_type: 'image/jpg')
    end
  end
end
