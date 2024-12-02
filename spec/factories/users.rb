FactoryBot.define do
  factory :user, class: "Panda::CMS::User" do
    firstname { "John" }
    lastname { "Doe" }
    sequence(:email) { |n| "user#{n}@example.com" }
  end
end
