require "rails_helper"

RSpec.describe PandaCms::User do
  let(:admin_user) { build(:admin_user) }
  let(:user) { build(:user) }

  describe "user factory" do
    it "creates a valid factory" do
      expect(user).to be_valid
    end

    it "does not create an admin" do
      expect(user.admin).to be false
    end
  end

  describe "admin user factory" do
    it "creates a valid factory" do
      expect(admin_user).to be_valid
    end

    it "creates an admin" do
      expect(admin_user.admin).to be true
    end
  end

  describe "validations" do
    it { should validate_presence_of(:firstname) }
    it { should validate_presence_of(:lastname) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  describe "associations" do
  end
end
