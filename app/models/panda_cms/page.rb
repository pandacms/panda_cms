require "awesome_nested_set"

module PandaCms
  class Page < ApplicationRecord
    acts_as_nested_set counter_cache: :children_count
    self.table_name = "panda_cms_pages"
    self.implicit_order_column = "lft"

    has_paper_trail versions: {
      class_name: "PandaCms::PageVersion"
    }

    after_save :after_save

    belongs_to :template, foreign_key: :panda_cms_template_id, class_name: "PandaCms::Template", inverse_of: :pages, optional: false, counter_cache: :pages_count
    has_many :blocks, through: :template
    has_many :block_contents, foreign_key: :panda_cms_page_id, class_name: "PandaCms::BlockContent", inverse_of: :page
    has_many :menu_items, foreign_key: :panda_cms_page_id, class_name: "PandaCms::MenuItem", inverse_of: :page
    has_many :menus, through: :menu_items
    has_many :menus_of_parent, through: :parent, source: :menus
    has_one :page_menu, foreign_key: :panda_cms_menu_id, class_name: "PandaCms::Menu", inverse_of: :start_page

    validates :title, presence: true
    validates :path,
      presence: true,
      uniqueness: true,
      format: {with: /\A\/.*\z/, message: "must start with a forward slash"}
    validates :parent, presence: true, unless: -> { path == "/" }
    validates :panda_cms_template_id, presence: true

    scope :ordered, -> { order(:lft) }

    private

    #
    # After save callbacks
    #
    # @return nil
    # @visibility private
    #
    def after_save
      generate_content_blocks
      update_existing_menu_items
      update_auto_menus
    end

    def generate_content_blocks
      template_block_ids = template.blocks.ids
      page_existing_block_ids = block_contents.map { |bc| bc.block.id }
      required_block_ids = template_block_ids - page_existing_block_ids

      if required_block_ids.count > 0
        required_block_ids.each do |block_id|
          PandaCms::BlockContent.find_or_create_by!(page: self, panda_cms_block_id: block_id, content: "")
        end
      end
    end

    #
    # Update text of existing menu items if the title differs
    #
    # @return nil
    # @todo Only run this if the page title has changed
    # @visibility private
    #
    def update_existing_menu_items
      menu_items.where.not(text: title).update_all(text: title)
    end

    #
    # Update any menus which include this page or its parent as a menu item
    #
    # @return nil
    # @visibility private
    #
    def update_auto_menus
      menus.find_each(&:generate_auto_menu_items)
      menus_of_parent.find_each(&:generate_auto_menu_items)
    end
  end
end
