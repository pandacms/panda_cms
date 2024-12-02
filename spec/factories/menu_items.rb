FactoryBot.define do
  factory :menu_item, class: "Panda::CMS::MenuItem" do
    text { "Menu Item" }
    association :menu, factory: :menu

    trait :with_page do
      association :page, factory: :page
    end

    trait :with_external_url do
      external_url { "https://example.com" }
    end
  end
end
