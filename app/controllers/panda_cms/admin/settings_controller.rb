module Panda
  module CMS
  class Admin::SettingsController < ApplicationController
    before_action :set_initial_breadcrumb, only: %i[index show]
    before_action :authenticate_admin_user!

    def index
    end

    def show
    end

    private

    def set_initial_breadcrumb
      add_breadcrumb "Settings", admin_settings_path
    end
  end
end
