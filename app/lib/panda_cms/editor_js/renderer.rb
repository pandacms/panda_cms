module PandaCms
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
        "<section class=\"content-section\">#{render_blocks(blocks)}</section>"
      end

      def article(blocks, title: nil)
        content = []
        content << "<h1>#{title}</h1>" if title
        content << render_blocks(blocks)
        "<article>#{content.join("\n")}</article>"
      end

      private

      def render_blocks(blocks)
        blocks.map { |block| render_block_with_cache(block) }.join("\n")
      end

      def validate_html(html)
        # First check if we have matching numbers of opening and closing tags
        opening_tags = html.scan(/<([a-z]+)[^>]*>/i)
        closing_tags = html.scan(/<\/([a-z]+)>/i)

        # Early return if tag counts don't match
        return "" unless opening_tags.length == closing_tags.length

        # Check tag order and nesting
        stack = []
        tag_pattern = /<\/?([a-z]+)[^>]*>/i
        position = 0

        while match = html[position..].match(tag_pattern)
          tag_name = match[1].downcase
          is_closing = match[0].start_with?("</")

          if is_closing
            return "" if stack.pop != tag_name
          else
            stack.push(tag_name)
          end

          position += match.begin(0) + match[0].length
        end

        stack.empty? ? html : ""
      end

      def render_block_with_cache(block)
        return "" if @validate_html && has_invalid_html?(block["data"])

        cache_key = "editor_js_block/#{block["type"]}/#{Digest::MD5.hexdigest(block["data"].to_json)}"
        cache_store.fetch(cache_key) do
          renderer_for(block).render
        end
      end

      def remove_empty_paragraphs(blocks)
        blocks.reject do |block|
          block["type"] == "paragraph" &&
            block["data"]["text"].blank? &&
            (blocks.last == block || next_block_is_empty?(blocks, block))
        end
      end

      def next_block_is_empty?(blocks, current_block)
        current_index = blocks.index(current_block)
        next_block = blocks[current_index + 1]
        next_block && next_block["type"] == "paragraph" && next_block["data"]["text"].blank?
      end

      def renderer_for(block)
        if custom_renderers[block["type"]]
          custom_renderers[block["type"]].new(block["data"], options)
        else
          default_renderer_for(block)
        end
      end

      def default_renderer_for(block)
        renderer_class = "PandaCms::EditorJs::Blocks::#{block["type"].classify}".constantize
        renderer_class.new(block["data"], options)
      rescue NameError
        PandaCms::EditorJs::Blocks::Base.new(block["data"], options)
      end

      def default_renderer_for(block)
        renderer_class = "PandaCms::EditorJs::Blocks::#{block["type"].classify}".constantize
        renderer_class.new(block["data"], options)
      rescue NameError
        PandaCms::EditorJs::Blocks::Base.new(block["data"], options)
      end

      private

      def has_invalid_html?(data)
        data.values.any? do |value|
          next unless value.is_a?(String)
          opening_tags = value.scan(/<([a-z]+)[^>]*>/i)
          closing_tags = value.scan(/<\/([a-z]+)>/i)
          opening_tags.length != closing_tags.length ||
            opening_tags.map(&:first) != closing_tags.map(&:first)
        end
      end
    end
  end
end
