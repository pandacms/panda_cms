ActionView::Base.field_error_proc = proc do |html_tag, instance|
  html = ""
  form_fields = %w[input select textarea trix-editor label].join(", ")
  error_class = "text-red-600 dark:text-red-500 bg-red-50 border-red-500 border-1 box-shadow-red-500 focus:ring-red-500 focus:border-red-500 dark:bg-red-900 dark:border-red-500 dark:focus:ring-red-500 dark:focus:border-red-500"
  message_class = "block w-full text-sm font-bold p-0 m-0 mt-1 text-red-700"
  autofocused = false

  Nokogiri::HTML::DocumentFragment.parse(html_tag).css(form_fields).each do |element|
    if form_fields.include?(element.node_name)
      if !autofocused
        # element.attribute("autofocus", "true")
        autofocused = true
      end

      message = "#{instance.object.class.human_attribute_name(instance.send(:sanitized_method_name))} "
      message += if instance.error_message.respond_to?(:each)
        "#{instance.error_message.uniq.to_sentence}."
      else
        "#{instance.error_message}."
      end

      if element.node_name.eql?("label")
        html = element.to_s
      else
        element.add_class(error_class)
        html = if element.get_attribute("data-prefix")
          "#{element}</div><div class=\"#{message_class}\">#{message}"
        elsif element.get_attribute("type") != "checkbox"
          "#{element}<div class=\"#{message_class}\">#{message}</div>"
        else
          element.to_s
        end
      end
    end
  end

  html.html_safe
end
