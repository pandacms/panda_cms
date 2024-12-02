# frozen_string_literal: true

module Panda
  module CMS
    module Admin
      class ContainerComponent < ViewComponent::Base
        renders_one :heading, "Panda::CMS::Admin::HeadingComponent"
        renders_one :tab_bar, "Panda::CMS::Admin::TabBarComponent"
        renders_one :slideover, "Panda::CMS::Admin::SlideoverComponent"
      end
    end
  end
end
