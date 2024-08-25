FactoryBot.define do
  factory :menu, class: "PandaCms::Menu" do
    sequence(:name) { |n| "Menu #{n}" }
    kind { "static" }
  end
end
