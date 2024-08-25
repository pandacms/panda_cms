module PandaCms
  class FormBuilder < ActionView::Helpers::FormBuilder
    include ActionView::Helpers::TagHelper

    def label(attribute, text = nil, options = {}, &block)
      super(attribute, text, options.reverse_merge(class: "font-medium text-sm leading-6 text-gray-500"))
    end

    def text_field(attribute, options = {})
      if options.dig(:data, :prefix)
        content_tag :div, class: container_styles do
          label(attribute) +
            content_tag(:div, class: "flex flex-grow") do
              content_tag(:span, class: "inline-flex items-center px-3 text-sm text-gray-900 bg-gray-200 border border-e-0 border-gray-300 rounded-s-md dark:bg-gray-600 dark:text-gray-400 dark:border-gray-600 whitespace-nowrap break-keep") { options.dig(:data, :prefix) } +
                super(attribute, options.reverse_merge(class: input_styles_prefix + " rounded-l-none"))
            end
        end
      else
        content_tag :div, class: container_styles do
          label(attribute) + super(attribute, options.reverse_merge(class: input_styles))
        end
      end
    end

    def email_field(attribute, options = {})
      content_tag :div, class: container_styles do
        label(attribute) + super(attribute, options.reverse_merge(class: input_styles))
      end
    end

    def password_field(attribute, options = {})
      content_tag :div, class: container_styles do
        label(attribute) + super(attribute, options.reverse_merge(class: input_styles))
      end
    end

    def select(method, choices = nil, options = {}, html_options = {}, &block)
      content_tag :div, class: container_styles do
        label(method) + super(method, choices, options, html_options.reverse_merge(class: input_styles))
      end
    end

    def collection_select(method, collection, value_method, text_method, options = {}, html_options = {})
      content_tag :div, class: container_styles do
        label(method) + super(method, collection, value_method, text_method, options, html_options.reverse_merge(class: input_styles))
      end
    end

    def time_zone_select(method, priority_zones = nil, options = {}, html_options = {})
      content_tag :div, class: container_styles do
        label(method) + super(method, priority_zones, options, html_options.reverse_merge(class: input_styles))
      end
    end

    def file_field(method, options = {})
      content_tag :div, class: container_styles do
        label(method) + super(method, options.reverse_merge(class: "file:rounded file:border-0 file:text-sm file:bg-white file:text-gray-500 hover:file:bg-gray-50 bg-white px-2.5 hover:bg-gray-50".concat(input_styles)))
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
        content_tag(:i, "", class: "fa-sharp fa-circle-check mr-2 pt-[0.2rem]") + value
      end

      @template.button_tag(value, options.reverse_merge(class: button_styles))
    end

    def submit(value = nil, options = {}) # => 7.1.3
      super(value, options.reverse_merge(class: button_styles))
    end

    def check_box(method, options = {}, checked_value = "1", unchecked_value = "0")
      content_tag :div, class: container_styles do
        label(method) + super(method, options.reverse_merge(class: "border-gray-300 ml-2"), checked_value, unchecked_value)
      end
    end

    def date_field(method, options = {})
      content_tag :div, class: container_styles do
        label(method) + super(method, options.reverse_merge(class: input_styles))
      end
    end

    private

    def input_styles
      "block w-full rounded-md border-0 p-2 text-gray-900 ring-1 ring-inset ring-mid placeholder:text-gray-300 focus:outline-panda-light focus:ring-1 focus:ring-inset focus:ring-dark sm:text-sm sm:leading-6 hover:pointer"
    end

    def input_styles_prefix
      input_styles.concat(" prefix")
    end

    def button_styles
      "inline-flex items-center rounded-md font-medium shadow-sm focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 text-dark border-2 border-dark bg-transparent hover:bg-light transition-all gap-x-1.5 px-3 py-2 text-base gap-x-1.5 px-2.5 py-1.5 text-sm mt-2 "
    end

    def container_styles
      "panda-field-container mb-2"
    end
  end
end
