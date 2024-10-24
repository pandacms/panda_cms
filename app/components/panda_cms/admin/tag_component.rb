# frozen_string_literal: true

module PandaCms
  module Admin
    class TagComponent < ViewComponent::Base
      attr_accessor :status, :text

      def initialize(status: :active, text: nil)
        @status = status.to_sym
        @text = text || status.to_s.humanize
      end

      def call
        classes = "inline-flex items-center py-1 px-2 text-xs font-medium rounded-md ring-1 ring-inset "

        classes += case @status
        when :active
          "text-white ring-black/30 bg-active border-0 "
        when :draft
          "text-black ring-black/30 bg-warning "
        when :inactive, :hidden
          "text-black ring-black/30 bg-black/5 bg-white "
        else
          "text-black bg-white "
        end

        content_tag :span, class: classes do
          @text
        end
      end
    end
  end
end
