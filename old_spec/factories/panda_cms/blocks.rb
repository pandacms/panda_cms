FactoryBot.define do
  factory :block, class: "PandaCms::Block" do
    kind { :plain_text }
    sequence(:name) { |n| "Text #{n}" }
    sequence(:key) { |n| :"main_#{n}" }
    template { PandaCms::Template.find_by(file_path: "layouts/page") || create(:template) }
  end
end
