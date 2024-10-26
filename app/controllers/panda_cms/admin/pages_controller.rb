# frozen_string_literal: true

module PandaCms
  module Admin
    class PagesController < ApplicationController
      before_action :set_initial_breadcrumb, only: %i[index edit new create update]
      before_action :set_paper_trail_whodunnit, only: %i[create update]
      before_action :authenticate_admin_user!

      # Lists all pages which can be managed by the administrator
      # @type GET
      # @return ActiveRecord::Collection A list of all pages
      def index
        homepage = PandaCms::Page.find_by(path: "/")
        render :index, locals: {root_page: homepage}
      end

      # Loads the add page form
      # @type GET
      def new
        locals = setup_new_page_form(page: page)
        render :new, locals: locals
      end

      # Loads the page editor
      # @type GET
      def edit
        add_breadcrumb page.title, edit_admin_page_path(page)

        render :edit, locals: {page: page, template: page.template}
      end

      # POST /admin/pages
      def create
        page = PandaCms::Page.new(page_params)
        if page.save
          page.update(path: page.parent.path + page.path) unless page.parent.path == "/"
          redirect_to edit_admin_page_path(page), notice: "The page was successfully created."
        else
          flash[:error] = "There was an error creating the page."
          locals = setup_new_page_form(page: page)
          render :new, locals: locals, status: :unprocessable_entity
        end
      end

      # @type PATCH/PUT
      # @return
      def update
        if page.update(page_params)
          redirect_to edit_admin_page_path(page),
            status: :see_other,
            flash: {success: "This page was successfully updated!"}
        else
          flash[:error] = "There was an error updating the page."
          render :edit, status: :unprocessable_entity
        end
      end

      private

      # Get the page from the ID
      # @type private
      # @return PandaCms::Page
      def page
        @page ||= if params[:id]
          PandaCms::Page.find(params[:id])
        else
          PandaCms::Page.new(template: PandaCms::Template.default)
        end
      end

      def set_initial_breadcrumb
        add_breadcrumb "Pages", admin_pages_path
      end

      def setup_new_page_form(page:)
        add_breadcrumb "Add Page", new_admin_page_path
        {page: page}
      end

      # Only allow a list of trusted parameters through.
      # @type private
      # @return ActionController::StrongParameters
      def page_params
        params.require(:page).permit(:title, :path, :panda_cms_template_id, :parent_id, :status)
      end
    end
  end
end
