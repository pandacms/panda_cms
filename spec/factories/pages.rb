FactoryBot.define do
  factory :page, class: "Panda::CMS::Page" do
    sequence(:title) { |n| "Page #{n}" }
    sequence(:path) { |n| "/page-#{n}" }
    association :template, factory: :template
    parent { Panda::CMS::Page.root }
    status { "active" }
  end
end
