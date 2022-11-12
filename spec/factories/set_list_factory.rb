FactoryBot.define do
  factory :set_list do
    name { "My amazing set" }
    user { User.first || User.create(email: "a@a.com", password: "123456789") }
  end
end
