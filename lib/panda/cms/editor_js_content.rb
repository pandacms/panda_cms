module Panda::CMS::EditorJsContent
  extend ActiveSupport::Concern

  included do
    include ActiveModel::Validations
    include ActiveModel::Callbacks

    before_save :generate_cached_content
  end

  def content_changed?
    will_save_change_to_content?
  end

  def generate_cached_content
    return if content.nil?

    self.cached_content = if content.is_a?(Hash) && content["source"] == "editorJS"
      Panda::CMS::EditorJs::Renderer.new(content).render
    else
      content.to_s
    end
  end
end
