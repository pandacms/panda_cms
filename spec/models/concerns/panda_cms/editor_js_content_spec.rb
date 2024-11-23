require "rails_helper"

RSpec.describe PandaCms::EditorJsContent do
  let(:test_class) do
    Class.new do |klass|
      def klass.before_save(*)
      end
      attr_accessor :content, :cached_content
      include PandaCms::EditorJsContent
    end
  end

  let(:model) { test_class.new }

  it "caches basic EditorJS content when saved" do
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

    model.content = editor_content
    model.generate_cached_content
    expect(model.cached_content).to include("<p>Test content</p>")
  end

  it "should directly copy content to cached_content if it's not EditorJS" do
    model.content = "Test content"
    model.generate_cached_content
    expect(model.cached_content).to eq("Test content")
  end
end
