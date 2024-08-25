# frozen_string_literal: true

module PandaCms
  module Admin
    class SlideoverComponent < ViewComponent::Base
      attr_reader :title

      def initialize(title: "Settings")
        @title = title
      end
    end
  end
end
