module Panda
  module CMS
    class FormBuilder < ActionView::Helpers::FormBuilder
      include ActionView::Helpers::TagHelper

      def label(attribute, text = nil, options = {}, &block)
        super(attribute, text, options.reverse_merge(class: label_styles))
      end

      def text_field(attribute, options = {})
        if options.dig(:data, :prefix)
          content_tag :div, class: container_styles do
            label(attribute) + meta_text(options) +
              content_tag(:div, class: "flex flex-grow") do
                content_tag(:span, class: "inline-flex items-center px-3 text-base border border-r-none rounded-s-md whitespace-nowrap break-keep") { options.dig(:data, :prefix) } +
                  super(attribute, options.reverse_merge(class: input_styles_prefix + " input-prefix rounded-l-none border-l-none"))
              end
          end
        else
          content_tag :div, class: container_styles do
            label(attribute) + meta_text(options) + super(attribute, options.reverse_merge(class: input_styles))
          end
        end
      end

      def email_field(attribute, options = {})
        content_tag :div, class: container_styles do
          label(attribute) + meta_text(options) + super(attribute, options.reverse_merge(class: input_styles))
        end
      end

      def datetime_field(attribute, options = {})
        content_tag :div, class: container_styles do
          label(attribute) + meta_text(options) + super(attribute, options.reverse_merge(class: input_styles))
        end
      end

      def text_area(method, options = {})
        content_tag :div, class: container_styles do
          label(method) + meta_text(options) + super(method, options.reverse_merge(class: input_styles))
        end
      end

      def password_field(attribute, options = {})
        content_tag :div, class: container_styles do
          label(attribute) + meta_text(options) + super(attribute, options.reverse_merge(class: input_styles))
        end
      end

      def select(method, choices = nil, options = {}, html_options = {}, &block)
        content_tag :div, class: container_styles do
          label(method) + meta_text(options) + super(method, choices, options, html_options.reverse_merge(class: input_styles))
        end
      end

      def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
        content_tag :div, class: container_styles do
          label(method) + meta_text(options) + super(method, collection, value_method, text_method, options, html_options.reverse_merge(class: input_styles))
        end
      end

      def time_zone_select(method, priority_zones = nil, options = {}, html_options = {})
        content_tag :div, class: container_styles do
          label(method) + meta_text(options) + super(method, priority_zones, options, html_options.reverse_merge(class: input_styles))
        end
      end

      def file_field(method, options = {})
        content_tag :div, class: container_styles do
          label(method) + meta_text(options) + super(method, options.reverse_merge(class: "file:rounded file:border-0 file:text-sm file:bg-white file:text-gray-500 hover:file:bg-gray-50 bg-white px-2.5 hover:bg-gray-50".concat(input_styles)))
        end
      end

      def button(value = nil, options = {}, &block) # => 7.1.3
        case value
        when Hash
          value, options = nil, value
        when Symbol
          value, options = nil, {name: field_name(value), id: field_id(value)}.merge!(options.to_h)
        end
        value ||= submit_default_value

        formmethod = options[:formmethod]
        if formmethod.present? && !/post|get/i.match?(formmethod) && !options.key?(:name) && !options.key?(:value)
          options.merge! formmethod: :post, name: "_method", value: formmethod
        end

        value = if block
          @template.capture { yield(value) }
        else
          content_tag(:i, "", class: "fa-sharp fa-circle-check mr-1 pt-[0.2rem]") + value
        end

        @template.button_tag(value, options.reverse_merge(class: button_styles))
      end

      def submit(value = nil, options = {}) # => 7.1.3
        super(value, options.reverse_merge(class: button_styles))
      end

      def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
        content_tag :div, class: container_styles do
          label(method) + meta_text(options) + super(method, options.reverse_merge(class: "border-gray-300 ml-2"), checked_value, unchecked_value)
        end
      end

      def date_field(method, options = {})
        content_tag :div, class: container_styles do
          label(method) + meta_text(options) + super(method, options.reverse_merge(class: input_styles))
        end
      end

      def rich_text_area(method, options = {})
        content_tag :div, class: container_styles do
          label(method) + meta_text(options) + super(method, options.reverse_merge(class: textarea_styles))
        end
      end

      def rich_text_field(method, options = {})
        content_tag :div, class: container_styles do
          label(method) + meta_text(options) + super(method, options.reverse_merge(class: textarea_styles))
        end
      end

      def meta_text(options)
        if options[:meta]
          content_tag :span, options[:meta], class: "block text-black/60 italic text-sm mb-2"
        end
      end

      private

      def label_styles
        "font-light inline-block mb-1 text-base leading-6"
      end

      def input_styles
        "bg-white block w-full rounded-md border border-mid focus:border-dark p-2 text-base text-dark outline-none focus:outline-none ring-0 focus:ring-0 focus:ring-black ring-offset-0 focus:ring-offset-0 shadow-none focus:shadow-none focus:text-black"
      end

      def input_styles_prefix
        input_styles.concat(" prefix")
      end

      def button_styles
        "inline-flex items-center rounded-md font-medium shadow-sm focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 text-dark border-2 border-dark bg-transparent hover:bg-light transition-all gap-x-1.5 px-3 py-2 text-base gap-x-1.5 px-2.5 py-1.5 text-sm mt-2 "
      end

      def container_styles
        "panda-cms-field-container mb-4"
      end

      def textarea_styles
        input_styles.concat(" min-h-32")
      end
    end
  end
end
