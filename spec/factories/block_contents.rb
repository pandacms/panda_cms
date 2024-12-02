FactoryBot.define do
  factory :block_content, class: "Panda::CMS::BlockContent" do
    association :block
    association :page
  end
end
