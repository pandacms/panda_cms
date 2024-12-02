FactoryBot.define do
  factory :template, class: "Panda::CMS::Template" do
    sequence(:name) { |n| "Template #{n}" }
    sequence(:file_path) { |n| "layouts/template_#{n}" }
  end
end
