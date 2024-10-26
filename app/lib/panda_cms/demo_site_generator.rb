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
    # @return void
    def create_templates
      # Templates
      initial_templates = [
        {name: "Homepage", file_path: "layouts/homepage", max_uses: 1},
        {name: "Page", file_path: "layouts/page"}
      ]

      initial_templates.each do |template|
        key = template[:name].downcase.to_sym
        @templates[key] = PandaCms::Template.find_or_create_by!(template)
      end

      PandaCms::Template.generate_missing_blocks

      @templates
    end

    #
    # Creates initial pages
    #
    # @return [Hash] A hash containing the created pages
    def create_pages
      @pages[:home] = PandaCms::Page.find_or_create_by!({path: "/", title: "Home", template: @templates[:homepage]})
      @pages[:about] = PandaCms::Page.find_or_create_by!({path: "/about", title: "About", template: @templates[:page], parent: @pages[:home]})
      @pages[:terms] = PandaCms::Page.find_or_create_by!({path: "/terms-and-conditions", title: "Terms & Conditions", template: @templates[:page], parent: @pages[:home], status: "hidden"})

      PandaCms::Page.reset_column_information
      PandaCms::Page.rebuild!

      @pages
    end

    #
    # Creates initial menus
    #
    # @return [Hash] A hash containing the created menus
    def create_menus
      @menus = {}
      @menus[:main] = PandaCms::Menu.find_or_create_by!(name: "Main Menu")
      @menus[:footer] = PandaCms::Menu.find_or_create_by!(name: "Footer Menu")

      # Automatically create main menu from homepage
      unless @pages[:home].nil?
        @menus[:main].update(kind: :auto, start_page: @pages[:home], depth: 1)
        @menus[:main].generate_auto_menu_items
      end

      @menus
    end
  end
end
