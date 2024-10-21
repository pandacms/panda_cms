# frozen_string_literal: true

module PandaCms
  # Text component
  # @param key [Symbol] The key to use for the text component
  # @param text [String] The text to display
  # @param editable [Boolean] If the text is editable or not (defaults to true)
  # @param options [Hash] The options to pass to the content_tag
  class RichTextComponent < ViewComponent::Base
    KIND = "rich_text"

    attr_accessor :editable
    attr_accessor :content
    attr_accessor :options

    def initialize(key: :text_component, text: "Lorem ipsum...", editable: true, **options)
      @key = key
      @text = text
      @options = options || {}
      @editable = editable
    end

    # Check if the element is editable and set up the content
    def before_render
      @editable &&= params[:embed_id].present? && params[:embed_id] == Current.page.id && Current.user.admin?
      block = PandaCms::Block.find_by(kind: "rich_text", key: @key, panda_cms_template_id: Current.page.panda_cms_template_id)
      block_content = block.block_contents.find_by(panda_cms_page_id: Current.page.id)
      @content = block_content.content.html_safe

      @options[:id] = "editor_rich_text_#{block_content.id.tr("-", "_")}"

      if @editable
        @options[:data] = {
          block_content_id: block_content&.id,
          mode: "rich-text"
        }
      end
    rescue => e
      if Rails.env.production?
        Sentry.capture_exception(e) if defined?(Sentry)
      else
        raise e
      end
      false
    end

    # Only render the component if there is some content set, or if the component is editable
    def render?
      @content.present? || @editable
    end
  end
end
