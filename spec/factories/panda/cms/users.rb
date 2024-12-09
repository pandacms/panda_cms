FactoryBot.define do
  factory :panda_cms_user, class: "Panda::CMS::User" do
    sequence(:email) { |n| "user#{n}@example.org" }
    sequence(:firstname) { |n| "User #{n}" }
    sequence(:lastname) { |n| "Lastname #{n}" }

    trait :admin do
      admin { true }
    end
  end
end
