FactoryBot.define do
  factory :user, class: "PandaCms::User" do
    firstname { "John" }
    lastname { "Doe" }
    sequence(:email) { |n| "user#{n}@example.com" }
  end
end
