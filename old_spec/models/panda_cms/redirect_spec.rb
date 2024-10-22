require "rails_helper"

RSpec.describe PandaCms::Redirect do
  describe "associations" do
    it { should belong_to(:origin_page).with_foreign_key(:origin_panda_cms_page_id) }
    it { should belong_to(:destination_page).with_foreign_key(:destination_panda_cms_page_id) }
  end

  describe "validations" do
    it { should validate_presence_of(:status_code) }
    it { should validate_presence_of(:visits) }
  end
end
