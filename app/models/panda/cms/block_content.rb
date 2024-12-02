module Panda
  module CMS
    class BlockContent < ApplicationRecord
      include EditorJsContent

      self.table_name = "panda_cms_block_contents"

      has_paper_trail versions: {
        class_name: "Panda::CMS::BlockContentVersion"
      }

      belongs_to :page, foreign_key: :panda_cms_page_id, class_name: "Panda::CMS::Page", inverse_of: :block_contents, optional: true, touch: true
      belongs_to :block, foreign_key: :panda_cms_block_id, class_name: "Panda::CMS::Block", inverse_of: :block_contents, optional: false

      validates :block, presence: true, uniqueness: {scope: :page}
    end
  end
end
