# frozen_string_literal: true

module PandaCms
  # Text component
  # @param key [Symbol] The key to use for the text component
  # @param text [String] The text to display
  # @param editable [Boolean] If the text is editable or not (defaults to true)
  # @param options [Hash] The options to pass to the content_tag
  class RichTextComponent < ViewComponent::Base
    KIND = "rich_text"

    def initialize(key: :text_component, text: "Lorem ipsum...", editable: true, **options)
      @key = key
      @text = text
      @options = options || {}
      @editable = editable
    end

    # Check if the element is editable and set up the content
    def before_render
      @editable &&= params[:embed_id].present? && params[:embed_id] == Current.page.id && Current.user&.admin?

      block = PandaCms::Block.find_by(kind: "rich_text", key: @key, panda_cms_template_id: Current.page.panda_cms_template_id)
      block_content = block.block_contents.find_by(panda_cms_page_id: Current.page.id)
      @content = block_content.content.html_safe
      @options[:id] = "editor_rich_text_#{block_content&.id&.tr("-", "_")}"
      @options[:class] ||= ""
      @options[:class] += " content-rich-text"

      if @editable
        @options[:data] = {
          block_content_id: block_content&.id
        }
      end
    rescue => e
      Sentry.capture_exception(e) if if_defined?(Sentry)
      false
    end
  end
end
