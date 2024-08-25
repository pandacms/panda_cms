FactoryBot.define do
  factory :block_content, class: "PandaCms::BlockContent" do
    page { create(:page) }
    block { create(:block) }
    sequence(:content) { |n| "This is a test #{n}." }
  end
end
