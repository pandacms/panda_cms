module Panda
  module CMS
    class PagesController < ApplicationController
      include ActionView::Helpers::TagHelper

      before_action :check_login_required, only: [:root, :show]
      after_action :record_visit, only: [:root, :show], unless: :ignore_visit?

      def root
        params[:path] = ""
        show
      end

      def show
        page = if @overrides&.dig(:page_path_match)
          Panda::CMS::Page.find_by(path: @overrides.dig(:page_path_match))
        else
          Panda::CMS::Page.find_by(path: "/" + params[:path].to_s)
        end

        Panda::CMS::Current.page = page || Panda::CMS::Page.find_by(path: "/404")
        if @overrides
          Panda::CMS::Current.page.title = @overrides&.dig(:title) || page.title
        end

        layout = page&.template&.file_path

        if page.nil? || page.status == "archived" || layout.nil?
          # This works for now, but we may want to override in future (e.g. custom 404s)
          render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found and return
        end

        template_vars = {
          page: page,
          title: Panda::CMS::Current.page&.title || Panda::CMS.config.title
        }

        render inline: "", assigns: template_vars, status: :ok, layout: layout
      end

      private

      def check_login_required
        if Panda::CMS.config.require_login_to_view && !user_signed_in?
          redirect_to panda_cms_maintenance_path and return
        end
      end

      def ignore_visit?
        # Ignore visits from bots (TODO: make this configurable)
        return true if /bot/i.match?(request.user_agent)
        # Ignore visits from Honeybadger
        return true if request.headers.to_h.key? "Honeybadger-Token"

        false
      end

      def record_visit
        RecordVisitJob.perform_later(
          url: request.url,
          user_agent: request.user_agent,
          referrer: request.referrer,
          ip_address: request.remote_ip,
          page_id: Panda::CMS::Current.page&.id,
          current_user_id: current_user&.id,
          params: params.to_unsafe_h.except(:controller, :action, :path),
          visited_at: Time.zone.now
        )
      end
    end
  end
end
