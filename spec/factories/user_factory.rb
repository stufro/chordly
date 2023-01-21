FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "123456789" }
    confirmed_at { Time.zone.now }
  end
end
