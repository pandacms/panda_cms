FactoryBot.define do
  factory :template, class: "PandaCms::Template" do
    sequence(:name) { |n| "Page Template #{n}" }
    file_path { "layouts/page" }
  end

  factory :homepage_template, class: "PandaCms::Template" do
    name { "Homepage Template" }
    file_path { "layouts/homepage" }
  end

  factory :different_template, class: "PandaCms::Template" do
    name { "Different Template" }
    file_path { "layouts/different_page" }
  end
end
