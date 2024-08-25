# frozen_string_literal: true

module PandaCms
  class MenuComponent < ViewComponent::Base
    attr_accessor :menu_item
    attr_accessor :children

    def initialize(name:, item_styles: "")
      @menu = PandaCms::Menu.find_by(name: name)
      @menu_items = @menu.menu_items.order(:lft) if @menu.present?
      @item_styles = item_styles
    end

    def render?
      @menu_items.present?
    end
  end
end
