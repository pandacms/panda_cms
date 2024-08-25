# frozen_string_literal: true

module PandaCms
  module Admin
    class ContainerComponent < ViewComponent::Base
      renders_one :heading, "PandaCms::Admin::HeadingComponent"
      renders_one :tab_bar, "PandaCms::Admin::TabBarComponent"
      renders_one :slideover, "PandaCms::Admin::SlideoverComponent"
    end
  end
end
