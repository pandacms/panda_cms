generator = PandaCms::DemoSiteGenerator.new
generator.create_templates
generator.create_pages
generator.create_menus
PandaCms::Template.generate_missing_blocks
