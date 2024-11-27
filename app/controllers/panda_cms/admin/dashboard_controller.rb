require "groupdate"

module PandaCms
  class Admin::DashboardController < ApplicationController
    before_action :set_initial_breadcrumb, only: %i[show]
    before_action :authenticate_admin_user!

    # GET /admin
    def show
    end

    private

    def set_initial_breadcrumb
      add_breadcrumb "Dashboard", PandaCms.route_namespace
    end
  end
end
