FactoryBot.define do
  factory :menu_item, class: "PandaCms::MenuItem" do
    sequence(:text) { |n| "Link #{n}" }
    external_url { "#" }
    menu
  end
end
