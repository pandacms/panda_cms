module PandaCms
  class BlockContent < ApplicationRecord
    self.table_name = "panda_cms_block_contents"

    has_paper_trail versions: {
      class_name: "PandaCms::BlockContentVersion"
    }

    belongs_to :page, foreign_key: :panda_cms_page_id, class_name: "PandaCms::Page", inverse_of: :block_contents, optional: true, touch: true
    belongs_to :block, foreign_key: :panda_cms_block_id, class_name: "PandaCms::Block", inverse_of: :block_contents, optional: false

    validates :block, presence: true, uniqueness: {scope: :page}

    before_save :generate_cache

    private

    def generate_cache
      self.cached_content = if content.is_a?(Hash) && content.dig("source") == "editorJS"
        EditorJs::Renderer.new(content).render
      else
        content
      end
    end
  end
end
