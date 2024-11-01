module EditorJsHelper
  def normalize_html(html)
    html.gsub(/\s+/, " ").gsub("> <", "><").strip
  end
end
