module Panda
  module CMS
    class Admin::FilesController < ApplicationController
      before_action :set_initial_breadcrumb, only: %i[index show]
      before_action :authenticate_admin_user!

      def index
        redirect_to admin_dashboard_path
      end

      def show
      end

      private

      def set_initial_breadcrumb
        add_breadcrumb "Media", admin_files_path
      end
    end
  end
end
