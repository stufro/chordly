FactoryBot.define do
  factory :survey_response do
    user
    survey_key { "next_features" }

    trait :completed do
      answers { { "next_feature" => "sharing", "ad_free" => "yes" } }
      completed_at { Time.current }
    end
  end
end
