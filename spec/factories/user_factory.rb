FactoryBot.define do
  factory :user do
    email { "a@a.com" }
    password { "123456789" }
    confirmed_at { Time.zone.now }
  end
end
