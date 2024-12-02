# frozen_string_literal: true

module Panda
  module CMS
    class GridComponent < ViewComponent::Base
      def initialize(columns: 1, spans: [1])
        @columns = "grid-cols-#{columns}"
        @colspans = []
        spans.each do |span|
          @colspans << "col-span-#{span}"
        end
      end
    end
  end
end
