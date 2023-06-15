FactoryBot.define do
  factory :user do
    name { 'ryoya' }
    age { 24 }
    gender { '男性' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
    confirmed_at { 1.day.ago }
    activated { true }
  end
end
