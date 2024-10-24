# frozen_string_literal: true

module PandaCms
  module Admin
    class ButtonComponent < ViewComponent::Base
      attr_accessor :text, :action, :link, :icon, :size, :data

      def initialize(text: "Button", action: nil, data: {}, link: "#", icon: nil, size: :regular, id: nil)
        @text = text
        @action = action
        @data = data
        @link = link
        @icon = icon
        @size = size
        @id = id
      end

      def call
        @icon = set_icon_from_action(@action) if @action && @icon.nil?
        icon = content_tag(:i, "", class: "mr-2 fa-regular fa-#{@icon}") if @icon
        @text = "#{icon} #{@text.titleize}".html_safe

        classes = "inline-flex items-center rounded-md font-medium shadow-sm focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 "

        case @size
        when :small, :sm
          classes += "gap-x-1.5 px-2.5 py-1.5 text-sm "
        when :medium, :regular, :md
          classes += "gap-x-1.5 px-3 py-2 text-base "
        when :large, :lg
          classes += "gap-x-2 px-3.5 py-2.5 text-lg "
        end

        classes += case @action
        when :save, :create
          "text-white bg-active"
        when :save_inactive
          "text-white bg-inactive"
        when :secondary
          "text-dark border-2 border-dark bg-transparent hover:bg-light transition-all "
        when :delete, :destroy, :danger
          "text-error border border-error bg-red-100 hover:bg-red-200 hover:text-error focus-visible:outline-red-300 "
        else
          "text-dark border-2 border-dark bg-transparent hover:bg-light transition-all "
        end

        content_tag :a, href: @link, class: classes, data: @data, id: @id do
          @text
        end
      end

      private

      def set_icon_from_action(action)
        case action
        when :add, :new, :create
          "plus"
        when :save
          "check"
        when :edit, :update
          "pencil"
        when :delete, :destroy
          "trash"
        end
      end
    end
  end
end
