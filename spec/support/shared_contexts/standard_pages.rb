RSpec.shared_context "with standard pages" do
  before(:each) do
    homepage = create_homepage
    create_about_page(homepage)
  end

  def create_homepage
    homepage_template = Panda::CMS::Template.find_or_create_by!(
      name: "Homepage",
      file_path: "layouts/homepage",
      max_uses: 1
    )

    homepage = Panda::CMS::Page.find_or_create_by!(
      path: "/",
      title: "Home",
      template: homepage_template
    )

    content_blocks = [
      {
        kind: "rich_text",
        name: "Introduction Text",
        key: "introduction_text",
        template: homepage_template,
        content: "<h1>Welcome to the Demo Website!</h1>"
      },
      {
        kind: "rich_text",
        name: "Main Content",
        key: "main_content",
        template: homepage_template,
        content: "<p>This is the main content of the homepage.</p>"
      }
    ]

    create_content_blocks(homepage, content_blocks)
    homepage
  end

  def create_about_page(homepage)
    page_template = Panda::CMS::Template.find_or_create_by!(
      name: "Page",
      file_path: "layouts/page"
    )

    about_page = Panda::CMS::Page.find_or_create_by!(
      path: "/about",
      title: "About",
      template: page_template,
      parent: homepage
    )

    content_blocks = [
      {
        kind: "rich_text",
        name: "Main Content",
        key: "main_content",
        template: page_template,
        content: "<p>This is the main content of the about page.</p>"
      },
      {
        kind: "code",
        name: "HTML Code",
        key: "html_code",
        template: page_template,
        content: "<p><strong>Here is some HTML code.</strong></p>"
      },
      {
        kind: "plain_text",
        name: "Plain Text",
        key: "plain_text",
        template: page_template,
        content: "Here is some plain text content."
      }
    ]

    create_content_blocks(about_page, content_blocks)
  end
end

def create_content_blocks(page, content_blocks)
  content_blocks.each do |block_data|
    Panda::CMS::BlockContent.find_or_create_by!(
      page: page,
      block: Panda::CMS::Block.find_or_create_by!(block_data.except(:content)),
      content: block_data[:content]
    )
  end
end
