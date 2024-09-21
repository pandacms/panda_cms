# frozen_string_literal: true

module PandaCms
  class MenuComponent < ViewComponent::Base
    #
    # Renders the menu item and its children
    #
    # @param [String] name The name of the menu
    # @param [String] current_path The current path of the request
    # @param [Hash] styles The CSS classes to apply to the menu items, containing "default", "inactive" and "active" keys
    # @return [void]
    def initialize(name:, current_path: "", styles: {})
      @menu = PandaCms::Menu.find_by(name: name)
      @menu_items = @menu.menu_items.order(:lft)

      # TODO: Set other styles
      # # <% if (request.path == "/" && active_link?(menu_item.page.path, match: :exact)) || (menu_item.page.path != "/" && active_link?(menu_item.page.path, match: :starts_with)) %>border-b-[#1a9597]<% else %><% end %>
      @css_class = styles[:default]
    end

    def render?
      @menu_items.any?
    end
  end
end
