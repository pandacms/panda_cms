module Panda
  module CMS
    module EditorJsContent
      extend ActiveSupport::Concern

      included do
        before_save :generate_cached_content

        def generate_cached_content
          self.cached_content = if content.is_a?(Hash) && content.dig("source") == "editorJS"
            EditorJs::Renderer.new(content).render
          else
            content
          end
        end
      end
    end
  end
end
