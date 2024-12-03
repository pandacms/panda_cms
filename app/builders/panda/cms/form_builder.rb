require "ostruct"

module Panda
  module CMS
    class FormBuilder < ActionView::Helpers::FormBuilder
      include ActionView::Helpers::TagHelper
      include ActionView::Helpers::FormTagHelper

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

      def email_field(method, options = {})
        wrap_field(method, options) do
          super(method, options.reverse_merge(class: input_styles))
        end
      end

      def datetime_field(method, options = {})
        wrap_field(method, options) do
          super(method, options.reverse_merge(class: input_styles))
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
        wrap_field(method, options) do
          super(
            method,
            priority_zones,
            options,
            html_options.reverse_merge(class: select_styles)
          )
        end
      end

      def file_field(method, options = {})
        content_tag :div, class: container_styles do
          label(method) + meta_text(options) + super(method, options.reverse_merge(class: "file:rounded file:border-0 file:text-sm file:bg-white file:text-gray-500 hover:file:bg-gray-50 bg-white px-2.5 hover:bg-gray-50".concat(input_styles)))
        end
      end

      def button(value = nil, options = {}, &block)
        value ||= submit_default_value
        options = options.dup

        # Handle formmethod specially
        if options[:formmethod] == "delete"
          options[:name] = "_method"
          options[:value] = "delete"
        end

        base_classes = [
          "inline-flex items-center rounded-md",
          "px-3 py-2",
          "text-sm font-semibold",
          "shadow-sm"
        ]

        # Only add fa-circle-check for non-block buttons
        base_classes << "fa-circle-check" unless block_given?

        options[:class] = [
          *base_classes,
          options[:class]
        ].compact.join(" ")

        if block_given?
          @template.button_tag(options, &block)
        else
          @template.button_tag(value, options)
        end
      end

      def submit(value = nil, options = {})
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
        wrap_field(method, options) do
          if defined?(ActionText)
            # For test environment
            if Rails.env.test?
              # Just render a textarea for testing
              text_area(method, options.reverse_merge(class: textarea_styles))
            else
              rich_text_area(method, options.reverse_merge(class: textarea_styles))
            end
          else
            text_area(method, options.reverse_merge(class: textarea_styles))
          end
        end
      end

      def meta_text(options)
        return unless options[:meta]
        @template.content_tag(:p, options[:meta], class: "block text-black/60")
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

      def submit_default_value
        (object.respond_to?(:persisted?) && object.persisted?) ? "Update" : "Create"
      end

      def wrap_field(method, options = {}, &block)
        @template.content_tag(:div, class: "panda-cms-field-container") do
          label(method, class: "font-light inline-block mb-1 text-base leading-6") +
            meta_text(options) +
            @template.content_tag(:div, class: field_wrapper_styles, &block)
        end
      end

      def select_styles
        "form-select w-full"
      end

      def field_wrapper_styles
        "mt-1"
      end
    end
  end
end
