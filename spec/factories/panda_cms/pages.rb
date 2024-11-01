FactoryBot.define do
  factory :page, class: "PandaCms::Page" do
    sequence(:title) { |n| "Page #{n}" }
    sequence(:path) { |n| "/page-#{n}" }
    association :template, factory: :template
    parent { PandaCms::Page.root }
    status { "active" }
  end
end
