module PandaCms
  class ApplicationController < ::ActionController::Base
    include ApplicationHelper
    include ::ApplicationHelper

    protect_from_forgery with: :exception

    # Add flash types for improved alert support with Tailwind
    add_flash_types :success, :warning, :error, :info

    before_action :set_current_request_details

    helper_method :breadcrumbs
    helper_method :current_user
    helper_method :user_signed_in?

    def breadcrumbs
      @breadcrumbs ||= []
    end

    def add_breadcrumb(name, path = nil)
      breadcrumbs << Breadcrumb.new(name, path)
    end

    # Set the current request details
    # @return [void]
    def set_current_request_details
      PandaCms::Current.request_id = request.uuid
      PandaCms::Current.user_agent = request.user_agent
      PandaCms::Current.ip_address = request.ip
      PandaCms::Current.root = request.base_url
      PandaCms::Current.page = nil
      PandaCms::Current.user ||= User.find_by(id: session[:user_id]) if session[:user_id]

      PandaCms.config.url ||= PandaCms::Current.root
    end

    def authenticate_user!
      redirect_to root_path, flash: {error: "Please login to view this!"} unless user_signed_in?
    end

    def authenticate_admin_user!
      redirect_to root_path, flash: {error: "Please login to view this!"} unless user_signed_in? && current_user.admin?
    end

    # Required for paper_trail and seems as good as convention these days
    def current_user
      PandaCms::Current.user
    end

    def user_signed_in?
      !!PandaCms::Current.user
    end
  end
end
