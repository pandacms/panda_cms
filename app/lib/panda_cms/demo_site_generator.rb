module PandaCms
  class DemoSiteGenerator
    attr_accessor :menus, :pages, :templates

    def initialize
      @menus = {}
      @pages = {}
      @templates = {}
    end

    #
    # Creates initial templates and empty blocks
    #
    # @return [Hash] A hash containing the created templates
    def create_templates
      # Templates
      initial_templates = [
        {name: "Homepage", file_path: "layouts/homepage", max_uses: 1},
        {name: "Page", file_path: "layouts/page"}
      ]

      initial_templates.each do |template|
        PandaCms::Template.find_or_create_by!(template)
      end

      PandaCms::Template.generate_missing_blocks
    end

    #
    # Creates initial pages
    #
    # @return [Hash] A hash containing the created pages
    def create_pages
      @pages[:home] = PandaCms::Page.find_or_create_by!({path: "/", title: "Home", template: @templates[:homepage]})
      @pages[:about] = PandaCms::Page.find_or_create_by!({path: "/about", title: "About", template: @templates[:page], parent: @pages[:home]})
      @pages[:terms] = PandaCms::Page.find_or_create_by!({path: "/terms-and-conditions", title: "Terms & Conditions", template: @templates[:page], parent: @pages[:home]})
    end

    #
    # Creates initial menus
    #
    # @return [Hash] A hash containing the created menus
    #
    def create_menus
      @menus = {}
      @menus[:main] = PandaCms::Menu.find_or_create_by!(name: "Main Menu")
      @menus[:footer] = PandaCms::Menu.find_or_create_by!(name: "Footer Menu")

      # Automatically create main menu from homepage
      @menus[:main].update(kind: :auto, start_page: @pages[:home])
      @menus[:main].generate_auto_menu_items
    end
  end
end
