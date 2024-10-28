module PandaCms
  module EditorJs
    module Blocks
      class Base
        attr_reader :data, :options

        def initialize(data, options = {})
          @data = data
          @options = options
        end

        def render
          ""
        end

        private

        def sanitize(text)
          Rails::Html::SafeListSanitizer.new.sanitize(text, tags: %w[b i u a code])
        end

        def html_safe(text)
          text.to_s.html_safe
        end
      end
    end
  end
end
