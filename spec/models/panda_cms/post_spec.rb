require "rails_helper"

RSpec.describe PandaCms::Post, type: :model do
  describe "editor content" do
    let(:post) { create(:post) }

    it "stores and caches EditorJS content" do
      editor_content = {
        "source" => "editorJS",
        "time" => Time.current.to_i,
        "blocks" => [
          {
            "type" => "paragraph",
            "data" => {
              "text" => "Test content"
            }
          }
        ]
      }

      post.content = editor_content
      post.save!
      post.reload

      expect(post.content).to eq(editor_content)
      expect(post.cached_content).to include("<p>Test content</p>")
    end
  end
end
