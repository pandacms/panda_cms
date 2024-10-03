# frozen_string_literal: true

module PandaCms
  class PageMenuComponent < ViewComponent::Base
    attr_accessor :menu_item
    attr_accessor :children

    def initialize(page:, start_depth:, styles: {})
      start_page = if page.depth == start_depth
        page
      else
        page.ancestors.find { |anc| anc.depth == start_depth }
      end

      menu = PandaCms::Menu.find_by(kind: "auto", start_page: start_page)
      @menu_item = menu.menu_items.order(:lft)&.first unless menu.nil?

      @children = menu_item&.descendants unless menu_item.nil?

      # Set some default styles for sanity
      @styles = styles
      @styles[:indent_with] ||= "pl-2"
    end
  end
end
