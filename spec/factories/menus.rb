FactoryBot.define do
  factory :menu, class: "Panda::CMS::Menu" do
    sequence(:name) { |n| "Menu #{n}" }
  end
end
