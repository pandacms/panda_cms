module PandaCms
  module EditorJs
    module Blocks
      class Table < Base
        def render
          content = data["content"]
          with_headings = data["withHeadings"]

          html_safe(<<~HTML)
            <div class="overflow-x-auto">
              <table class="min-w-full">
                #{render_rows(content, with_headings)}
              </table>
            </div>
          HTML
        end

        private

        def render_rows(content, with_headings)
          rows = []

          content.each_with_index do |row, index|
            rows << if index == 0 && with_headings
              render_header_row(row)
            else
              render_data_row(row)
            end
          end

          rows.join("\n")
        end

        def render_header_row(row)
          cells = row.map { |cell| "<th>#{sanitize(cell)}</th>" }
          "<tr>#{cells.join}</tr>"
        end

        def render_data_row(row)
          cells = row.map { |cell| "<td>#{sanitize(cell)}</td>" }
          "<tr>#{cells.join}</tr>"
        end
      end
    end
  end
end
