FactoryBot.define do
  factory :post, class: "PandaCms::Post" do
    sequence(:title) { |n| "Test Post #{n}" }
    sequence(:slug) { |n| "/test-post-#{n}" }
    status { "active" }
    association :user, factory: :user
    content { {} }
  end
end
