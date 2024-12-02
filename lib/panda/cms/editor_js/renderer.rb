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
          return "" if content.nil? || !content.is_a?(Hash) || !content["blocks"]

          blocks = remove_empty_paragraphs(content["blocks"])
          rendered = blocks.map { |block| render_block_with_cache(block) }.join("\n")

          @validate_html ? validate_html(rendered) : rendered
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

          # Parse input for validation
          input = html.to_s

          # Check for unclosed or improperly nested tags
          stack = []
          input.scan(/<\/?(\w+)[^>]*>/) do |tag, _|
            if tag =~ /^(\w+)$/  # Opening tag
              stack.push($1)
            elsif tag =~ /^\/(\w+)$/  # Closing tag
              return "" if stack.empty? || stack.pop != $1
            end
          end

          # Check if all tags were closed
          return "" unless stack.empty?

          # Check for malformed attributes
          return "" if /=[^"'\s][^\s>]*/.match?(input)

          # Check for improperly nested paragraph tags
          doc = Nokogiri::HTML.fragment(input)
          return "" if doc.css("p p").any?

          html
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
      end
    end
  end
end
