module Panda
  module CMS
    module EditorJs
      class Renderer
        attr_reader :content, :options, :custom_renderers, :cache_store

        def initialize(content, options = {})
          @content = content
          @options = options
          @custom_renderers = options.delete(:custom_renderers) || {}
          @cache_store = options.delete(:cache_store) || Rails.cache
          @validate_html = options.delete(:validate_html) || false
        end

        def render
          return "" if content.nil? || content.empty? || !content["blocks"]

          blocks = content["blocks"].reject { |block| empty_paragraph?(block) }
          rendered = blocks.map do |block|
            rendered_block = render_block(block)
            # Apply HTML validation if enabled
            @validate_html ? validate_html(rendered_block) : rendered_block
          end.join("\n")

          rendered.presence || ""
        end

        def section(blocks)
          return "" if blocks.nil? || blocks.empty?

          content = {"blocks" => blocks}
          rendered = self.class.new(content, options).render

          "<section class=\"content-section\">#{rendered}</section>"
        end

        def article(blocks, title: nil)
          return "" if blocks.nil? || blocks.empty?

          content = {"blocks" => blocks}
          rendered = self.class.new(content, options).render

          [
            "<article>",
            (title ? "<h1>#{title}</h1>" : ""),
            rendered,
            "</article>"
          ].join("\n")
        end

        private

        def validate_html(html)
          return "" if html.blank?

          begin
            config = Sanitize::Config::RELAXED.dup
            config[:elements] = config[:elements] + ["figure", "figcaption"]
            config[:attributes] = config[:attributes].merge({
              "figure" => ["class"],
              "blockquote" => ["class"],
              "p" => ["class"],
              "figcaption" => []
            })

            sanitized = Sanitize.fragment(html, config)

            # Return the original HTML if sanitization doesn't remove content
            sanitized.present? ? html : ""
          rescue => e
            Rails.logger.error("HTML validation error: #{e.message}")
            ""
          end
        end

        def render_block_with_cache(block)
          cache_key = "editor_js_block/#{block["type"]}/#{Digest::MD5.hexdigest(block["data"].to_json)}"

          cache_store.fetch(cache_key) do
            renderer = renderer_for(block)
            renderer.render
          end
        end

        def renderer_for(block)
          if custom_renderers[block["type"]]
            custom_renderers[block["type"]].new(block["data"], options)
          else
            default_renderer_for(block)
          end
        end

        def default_renderer_for(block)
          renderer_class = "Panda::CMS::EditorJs::Blocks::#{block["type"].classify}".constantize
          renderer_class.new(block["data"], options)
        rescue NameError
          Panda::CMS::EditorJs::Blocks::Base.new(block["data"], options)
        end

        def remove_empty_paragraphs(blocks)
          blocks.reject do |block|
            block["type"] == "paragraph" && block["data"]["text"].blank?
          end
        end

        def empty_paragraph?(block)
          block["type"] == "paragraph" && block["data"]["text"].blank?
        end

        def render_block(block)
          renderer = renderer_for(block)
          renderer.render
        end
      end
    end
  end
end
