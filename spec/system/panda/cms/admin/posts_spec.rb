require "system_helper"

RSpec.describe "Admin Posts", type: :system do
  before do
    login_as_admin
    @other_admin = create(:panda_cms_user, admin: true)
  end

  describe "creating a post" do
    before { visit admin_posts_path }

    it "creates a new post with editor content" do
      click_on "Add Post"

      # Wait for page to load
      expect(page).to have_current_path(new_admin_post_path)
      expect(page).to have_content("Add Post")

      # Wait for EditorJS to initialize
      # pause
      expect(page).to have_css("#editorjs")
      expect(page).to have_css(".codex-editor")

      # Fill in form fields
      fill_in "post_title", with: "Test Post"
      fill_in "post_slug", with: "/test-post"
      select @other_admin.name, from: "post_user_id"
      fill_in "post_published_at", with: Time.current.strftime("%Y-%m-%dT%H:%M")
      select "Active", from: "post_status"

      # Wait for editor to be ready
      expect(page).to have_css(".ce-block")

      # Add content to the editor
      pause

      # Submit the form
      click_button "Create Post"

      expect(page).to have_text("Post was successfully created", wait: 5)

      # Verify the content was saved
      post = Panda::CMS::Post.last
      expect(post.content).to be_a(Hash)
      expect(post.content["blocks"]).to be_an(Array)
      expect(post.content["blocks"]).to include(
        include("type" => "header", "data" => include("text" => "Test Header"))
      )
    end
  end

  describe "editing a post" do
    let(:post) { create(:panda_cms_post, title: "Original Post Title") }

    it "updates an existing post with new editor content" do
      visit edit_admin_post_path(post)

      # Wait for page to load
      expect(page).to have_current_path(edit_admin_post_path(post))
      expect(page).to have_content("Edit Post")

      # Wait for form fields to be ready
      expect(page).to have_field("post_title", wait: 10)
      expect(page).to have_field("post_slug")

      # Fill in form fields
      fill_in "post_title", with: "Updated Post Title"
      fill_in "post_slug", with: "/updated-test-post"

      # Wait for EditorJS to initialize
      expect(page).to have_css("#editorjs")
      expect(page).to have_css(".codex-editor")

      new_content = {
        "time" => Time.current.to_i * 1000,
        "blocks" => [
          {
            "type" => "header",
            "data" => {
              "text" => "Updated Header",
              "level" => 2
            }
          }
        ],
        "version" => "2.28.2"
      }.to_json

      # Wait for editor to be available and then update content
      page.execute_script(<<~JS)
        function waitForEditor() {
          return new Promise((resolve) => {
            const checkEditor = setInterval(() => {
              if (window.editor && window.editor.isReady) {
                clearInterval(checkEditor);
                resolve(window.editor);
              }
            }, 100);
          });
        }

        async function setupEditor() {
          const editor = await waitForEditor();
          await editor.clear();
          await editor.render(#{new_content});
          const savedData = await editor.save();
          document.getElementById('editor-content-input').value = JSON.stringify(savedData);
        }

        setupEditor();
      JS

      # Wait for editor to be ready
      expect(page).to have_css(".ce-block")

      # Submit the form
      click_button "Update Post"

      expect(page).to have_text("This post was successfully updated", wait: 5)

      # Verify the content was updated
      post.reload
      expect(post.content).to be_a(Hash)
      expect(post.content["blocks"]).to be_an(Array)
      expect(post.content["blocks"]).to include(
        include("type" => "header", "data" => include("text" => "Updated Header"))
      )
    end
  end
end
