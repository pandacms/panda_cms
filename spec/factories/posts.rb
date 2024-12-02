FactoryBot.define do
  factory :post, class: "Panda::CMS::Post" do
    sequence(:title) { |n| "Test Post #{n}" }
    sequence(:slug) { |n| "/test-post-#{n}" }
    status { "active" }
    association :user, factory: :user
  end
end
