# frozen_string_literal: true

module Panda
  module CMS
    module Admin
      class MenusController < ApplicationController
        before_action :set_initial_breadcrumb, only: %i[index]
        before_action :authenticate_admin_user!

        # Lists all menus which can be managed by the administrator
        # @type GET
        # @return ActiveRecord::Collection An array of all menus
        def index
          menus = Panda::CMS::Menu.order(:name)
          render :index, locals: {menus: menus}
        end

        private

        def menu
          @menu ||= Panda::CMS::Menu.find(params[:id])
        end

        def set_initial_breadcrumb
          add_breadcrumb "Menus", admin_menus_path
        end
      end
    end
  end
end
