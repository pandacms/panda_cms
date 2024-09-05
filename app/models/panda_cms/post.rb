require "awesome_nested_set"

module PandaCms
  class Post < ApplicationRecord
    self.table_name = "panda_cms_posts"

    has_paper_trail versions: {
      class_name: "PandaCms::PostVersion"
    }

    belongs_to :user, class_name: "PandaCms::User"

    validates :title, presence: true
    validates :slug, presence: true, uniqueness: true, format: {with: /\A[a-z0-9-]+\z/}

    scope :ordered, -> { order(published_at: :desc) }
    scope :with_user, -> { includes(:user) }

    has_rich_text :post_content

    belongs_to :tag, class_name: "PandaCms::PostTag", foreign_key: :post_tag_id

    enum :status, {
      active: "active",
      draft: "draft",
      hidden: "hidden",
      archived: "archived"
    }

    def to_param
      slug.to_s
    end

    def excerpt(length = 100, squish: true)
      excerpt = post_content.to_plain_text
      excerpt = excerpt.squish if squish
      excerpt.truncate(length).html_safe
    end

    def path
      "/" + PandaCms.posts[:prefix] + slug.to_s
    end

    def formatted_slug
      if params[:slug][0] != "/"
        "/#{params[:slug]}"
      else
        params[:slug]
      end
    end
  end
end
