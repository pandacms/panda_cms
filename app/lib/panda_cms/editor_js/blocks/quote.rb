module PandaCms
  module EditorJs
    module Blocks
      class Quote < Base
        def render
          text = sanitize(data["text"])
          caption = sanitize(data["caption"])
          alignment = data["alignment"] || "left"

          html_safe(
            "<figure class=\"text-#{alignment}\">" \
              "<blockquote><p>#{text}</p></blockquote>" \
              "#{caption_element(caption)}" \
            "</figure>"
          )
        end

        private

        def caption_element(caption)
          return "" if caption.blank?
          "<figcaption>#{caption}</figcaption>"
        end
      end
    end
  end
end
