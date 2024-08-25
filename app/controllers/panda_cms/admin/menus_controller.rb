# frozen_string_literal: true

module PandaCms
  module Admin
    class MenusController < ApplicationController
      before_action :set_initial_breadcrumb, only: %i[index new edit create update]
      before_action :set_paper_trail_whodunnit, only: %i[create update]
      before_action :authenticate_admin_user!

      # Lists all menus which can be managed by the administrator
      # @type GET
      # @return ActiveRecord::Collection An array of all menus
      def index
        menus = PandaCms::Menu.order(:name)
        render :index, locals: {menus: menus}
      end

      # Loads the menu editor
      # @type GET
      def edit
        add_breadcrumb menu.name, edit_admin_menu_path(menu)
      end

      # GET /admin/menus/new
      # @type GET
      def new
        @menu = PandaCms::Menu.new
        @menu.menu_items.new
        set_new_menu_breadcrumb
      end

      # POST /admin/menus
      def create
        @menu = PandaCms::Menu.new(menu_params)

        if @menu.save
          redirect_to admin_menus_path, notice: "Menu was successfully created."
        else
          flash[:error] = @menu.errors.full_messages.join(", ")
          set_new_menu_breadcrumb
          render :new, status: :unprocessable_entity
        end
      end

      # @type PATCH/PUT
      # @return
      def update
        if menu.update!(menu_params)
          redirect_to edit_admin_menu_path(menu),
            status: :see_other,
            flash: {success: "This menu was successfully updated!"}
        else
          add_breadcrumb menu.name, edit_admin_menu_path(menu)
          flash[:error] = "There was an error updating the menu."
          render :edit, status: :unprocessable_entity
        end
      end

      private

      def menu
        @menu ||= PandaCms::Menu.find(params[:id])
      end

      def set_initial_breadcrumb
        add_breadcrumb "Menus", admin_menus_path
      end

      def set_new_menu_breadcrumb
        add_breadcrumb "Add New Menu", new_admin_menu_path
      end

      # Only allow a list of trusted parameters through.
      # @type private
      # @return ActionController::StrongParameters
      def menu_params
        params.require(:menu).permit(:name, menu_items_attributes: %i[id text external_url sort_order panda_cms_page_id _destroy])
      end
    end
  end
end
