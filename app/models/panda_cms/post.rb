require "awesome_nested_set"

module PandaCms
  class Post < ApplicationRecord
    self.table_name = "panda_cms_posts"

    has_paper_trail versions: {
      class_name: "PandaCms::PostVersion"
    }

    belongs_to :user, class_name: "PandaCms::User"

    validates :title, presence: true

    scope :ordered, -> { order(published_at: :desc) }

    def excerpt(length = 100)
      content.gsub(/<[^>]*>/, "").truncate(length)
    end

    def path
      PandaCms.posts[:prefix] + "/" + slug.to_s
    end
  end
end
