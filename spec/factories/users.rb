FactoryBot.define do
  factory :user do
    name { 'ryoya' }
    age { 24 }
    gender { '男性' }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { 'password' }
  end
end
