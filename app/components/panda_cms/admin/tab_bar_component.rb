# frozen_string_literal: true

module PandaCms
  module Admin
    class TabBarComponent < ViewComponent::Base
      attr_reader :tabs

      def initialize(tabs: [])
        @tabs = tabs
      end
    end
  end
end
