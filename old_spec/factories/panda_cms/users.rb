FactoryBot.define do
  factory :user, class: "PandaCms::User" do
    sequence(:firstname) { |n| "Firstname#{n}" }
    sequence(:lastname) { |n| "Lastname#{n}" }
    sequence(:email) { |n| "#{firstname}.#{lastname}@example.org" }
    image_url { "MyString" }
    admin { false }
  end

  factory :admin_user, class: "PandaCms::User" do
    sequence(:firstname) { |n| "FirstnameAdmin#{n}" }
    sequence(:lastname) { |n| "LastnameAdmin#{n}" }
    sequence(:email) { |n| "#{firstname}.#{lastname}.admin@example.org" }
    image_url { "MyString" }
    admin { true }
  end
end
