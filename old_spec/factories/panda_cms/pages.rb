FactoryBot.define do
  factory :page, class: "PandaCms::Page" do
    sequence(:path) { |n| "/page-#{n}" }
    sequence(:title) { |n| "Sample Page #{n}" }
    parent { PandaCms::Page.find_by(path: "/") || create(:homepage) }
    template { PandaCms::Template.find_by(file_path: "layouts/page") || create(:template) }
  end

  factory :homepage, class: "PandaCms::Page" do
    path { "/" }
    title { "Homepage" }
    parent { nil }
    template { PandaCms::Template.find_by(file_path: "layouts/homepage") || create(:homepage_template) }
  end
end
