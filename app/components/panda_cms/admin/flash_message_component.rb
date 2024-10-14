# frozen_string_literal: true

module PandaCms
  module Admin
    class FlashMessageComponent < ::ViewComponent::Base
      attr_reader :kind, :message

      def initialize(message:, kind:)
        @kind = kind.to_sym
        @message = message
      end

      def text_colour_css
        case kind
        when :success
          "text-active"
        when :alert, :error
          "text-error"
        when :warning
          "text-warning"
        when :info, :notice
          "text-active"
        else
          "text-mid"
        end
      end

      def icon_css
        case kind
        when :success
          "fa-circle-check"
        when :alert
          "fa-circle-xmark"
        when :warning
          "fa-triangle-exclamation"
        when :info, :notice
          "fa-circle-info"
        else
          "fa-circle-info"
        end
      end
    end
  end
end
