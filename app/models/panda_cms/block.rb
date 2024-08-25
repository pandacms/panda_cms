module PandaCms
  class Block < ApplicationRecord
    self.table_name = "panda_cms_blocks"

    belongs_to :template, foreign_key: :panda_cms_template_id, class_name: "PandaCms::Template", inverse_of: :blocks, optional: true
    has_many :block_contents, foreign_key: :panda_cms_block_id, class_name: "PandaCms::BlockContent", inverse_of: :block

    validates :kind, presence: true
    validates :name, presence: true
    validates :key, presence: true, uniqueness: {scope: :panda_cms_template_id, case_sensitive: false}

    # Validation for presence on template intentionally skipped to allow global elements

    # NB: Commented out values are not yet implemented
    enum :kind, {
      plain_text: "plain_text",
      rich_text: "rich_text",
      iframe: "iframe",
      list: "list"
      # image: "image",
      # video: "video",
      # audio: "audio",
      # file: "file",
      # code: "code",
      # iframe: "iframe",
      # quote: "quote",
      # list: "list"
      # table: "table",
      # form: "form"
    }
  end
end
