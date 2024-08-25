module PandaCms
  class Menu < ApplicationRecord
    self.table_name = "panda_cms_menus"

    after_save :generate_auto_menu_items, if: -> { kind == "auto" }

    has_many :menu_items, -> { order(lft: :asc) }, foreign_key: :panda_cms_menu_id, class_name: "PandaCms::MenuItem", inverse_of: :menu
    belongs_to :start_page, class_name: "PandaCms::Page", foreign_key: "start_page_id", inverse_of: :page_menu, optional: true

    accepts_nested_attributes_for :menu_items, reject_if: :all_blank, allow_destroy: true

    validates :name, presence: true, uniqueness: {case_sensitive: false}
    validates :kind, presence: true, inclusion: {in: ["static", "auto"]}
    validate :validate_start_page

    def generate_auto_menu_items
      return false if kind != "auto"

      # NB: Transactions are not distributed across database connections
      transaction do
        menu_items.destroy_all
        menu_item_root = menu_items.create(text: start_page.title, panda_cms_page_id: start_page.id)
        generate_menu_items(parent_menu_item: menu_item_root, parent_page: start_page)
      end
    end

    private

    def generate_menu_items(parent_menu_item:, parent_page:)
      parent_page.children.where(status: [:active]).each do |page|
        menu_item = menu_items.create(text: page.title, panda_cms_page_id: page.id, parent: parent_menu_item)
        if page.children
          generate_menu_items(parent_menu_item: menu_item, parent_page: page)
        end
      end
    end

    #
    # Validate that the start page is set if the menu is of kind auto
    #
    # @return nil
    # @visibility private
    #
    def validate_start_page
      if kind == "auto" && start_page.nil?
        errors.add(:start_page, "can't be blank")
      end
    end
  end
end
