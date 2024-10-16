# frozen_string_literal: true

module PandaCms
  class PageMenuComponent < ViewComponent::Base
    attr_accessor :page
    attr_accessor :menu_item
    attr_accessor :styles

    def initialize(page:, start_depth:, styles: {})
      @page = page

      unless @page.nil?
        start_page = if @page.depth == start_depth
          @page
        else
          @page.ancestors.find { |anc| anc.depth == start_depth }
        end

        menu = start_page&.page_menu
        return if menu.nil?

        @menu_item = menu.menu_items.order(:lft)&.first

        # Set some default styles for sanity
        @styles = styles
        @styles[:indent_with] ||= "pl-2"
      end
    end

    def render?
      @page.path != "/" && @page.page_menu
    end
  end
end
