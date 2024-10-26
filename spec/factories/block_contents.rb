FactoryBot.define do
  factory :block_content, class: "PandaCms::BlockContent" do
    association :block
    association :page
  end
end
