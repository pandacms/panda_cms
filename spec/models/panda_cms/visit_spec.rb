require "rails_helper"

RSpec.describe PandaCms::Visit do
  describe "associations" do
    it { should belong_to(:page).optional }
    it { should belong_to(:user).optional }
    it { should belong_to(:redirect).optional }
  end
end
