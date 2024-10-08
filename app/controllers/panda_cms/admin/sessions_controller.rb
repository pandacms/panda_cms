# frozen_string_literal: true

module PandaCms
  module Admin
    class SessionsController < ApplicationController
      layout "panda_cms/public"

      def new
        @providers = PandaCms.config.authentication.select { |_, v| v[:enabled] && !v[:hidden] }.keys
      end

      def create
        user_info = request.env.dig("omniauth.auth", "info")
        provider = params[:provider].to_sym

        unless PandaCms.config.authentication.dig(provider, :enabled)
          Rails.logger.error "Authentication provider '#{provider}' is not enabled"
          redirect_to admin_login_path, flash: {error: t("panda_cms.admin.sessions.create.error")}
          return
        end

        user = PandaCms::User.find_by(email: user_info["email"])

        if !user && PandaCms.config.authentication.dig(provider, :create_account_on_first_login)
          create_as_admin = PandaCms.config.authentication.dig(provider, :create_as_admin)

          # Always create the first user as admin, regardless of what our settings look like
          # else we can't ever really login. :)
          if !create_as_admin
            create_as_admin = true if !create_as_admin && PandaCms::User.count.zero?
          end

          if user_info["first_name"] && user_info["last_name"]
            firstname = user_info["first_name"]
            lastname = user_info["last_name"]
          elsif user_info["name"]
            firstname, lastname = user_info["name"].split(" ", 2)
          end

          user = User.find_or_create_by(
            email: user_info["email"]
          ) do |u|
            u.firstname = firstname
            u.lastname = lastname
            u.admin = create_as_admin
            u.image_url = user_info["image"]
          end
        end

        if user.nil? || !user.admin?
          # User can't be found with this email address or can't login
          Rails.logger.info "User #{user.id} attempted admin login, is not admin." if user && !user.admin
          redirect_to admin_login_path, flash: {error: t("panda_cms.admin.sessions.create.error")}
          return
        end

        session[:user_id] = user.id
        PandaCms::Current.user = user

        redirect_path = request.env["omniauth.origin"] || admin_dashboard_path
        redirect_to redirect_path, flash: {success: t("panda_cms.admin.sessions.create.success")}
      rescue ::OmniAuth::Strategies::OAuth2::CallbackError => e
        Rails.logger.error "OAuth2 login callback error: #{e.message}"
        redirect_to admin_login_path, flash: {error: t("panda_cms.admin.sessions.create.error")}
      rescue ::OAuth2::Error => e
        Rails.logger.error "OAuth2 login error: #{e.message}"
        redirect_to admin_login_path, flash: {error: t("panda_cms.admin.sessions.create.error")}
      rescue => e
        Rails.logger.error "Unknown login error: #{e.message}"
        redirect_to admin_login_path, flash: {error: t("panda_cms.admin.sessions.create.error")}
      end

      def failure
        Rails.logger.error "Login failure: #{params[:message]} from #{params[:origin]} using #{params[:strategy]}"
        redirect_to admin_login_path, flash: {error: t("panda_cms.admin.sessions.create.error")}
      end

      def destroy
        PandaCms::Current.user = nil
        session[:user_id] = nil
        redirect_to admin_login_path, flash: {success: t("panda_cms.admin.sessions.destroy.success")}
      end
    end
  end
end
