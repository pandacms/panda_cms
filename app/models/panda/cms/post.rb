require "awesome_nested_set"

module Panda
  module CMS
    class Post < ApplicationRecord
      include ::Panda::CMS::EditorJsContent

      self.table_name = "panda_cms_posts"

      has_paper_trail versions: {
        class_name: "Panda::CMS::PostVersion"
      }

      has_rich_text :post_content

      belongs_to :user, class_name: "Panda::CMS::User"

      validates :title, presence: true
      validates :slug,
        presence: true,
        uniqueness: true,
        format: {
          with: /\A\/[a-z0-9-]+\z/,
          message: "must start with a forward slash and contain only lowercase letters, numbers, and hyphens"
        }

      scope :ordered, -> { order(published_at: :desc) }
      scope :with_user, -> { includes(:user) }

      enum :status, {
        active: "active",
        draft: "draft",
        hidden: "hidden",
        archived: "archived"
      }

      def to_param
        formatted_slug.to_s
      end

      def excerpt(length = 100, squish: true)
        excerpt = post_content.to_plain_text
        excerpt = excerpt.squish if squish
        excerpt.truncate(length).html_safe
      end

      def path
        "/" + Panda::CMS.config.posts[:prefix] + slug.to_s
      end

      def formatted_slug
        if slug[0] == "/"
          slug[1, slug.length].to_s
        else
          slug
        end
      end
    end
  end
end
