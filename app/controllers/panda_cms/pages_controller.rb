module PandaCms
  class PagesController < ApplicationController
    include ActionView::Helpers::TagHelper

    def root
      params[:path] = ""
      show
    end

    def show
      if PandaCms.require_login_to_view && !user_signed_in?
        redirect_to panda_cms_maintenance_path and return
      end

      path_to_find = "/" + params[:path].to_s
      page = Page.find_by(path: path_to_find) || Page.find_by(path: "/404")
      PandaCms::Current.page = page
      layout = page&.template&.file_path

      # TODO: If page is active?
      if page && layout
        globals = {
          page: page,
          title: page.title
        }

        unless ignore_visit?
          RecordVisitJob.perform_later(
            url: request.url,
            user_agent: request.user_agent,
            referrer: request.referrer,
            ip_address: request.remote_ip,
            page_id: page.id,
            current_user_id: current_user&.id,
            params: params.to_unsafe_h.except(:controller, :action, :path),
            visited_at: Time.zone.now
          )
        end

        render inline: "", assigns: globals, status: :ok, layout: layout
      else
        # This works for now, but we may want to override in future (e.g. custom 404s)
        render file: "#{Rails.root}/public/404.html", layout: false, status: :not_found
      end
    end

    private

    def ignore_visit?
      # Ignore visits from bots (TODO: make this configurable)
      return true if /bot/i.match?(request.user_agent)
      # Ignore visits from Honeybadger
      return true if request.headers.to_h.key? "Honeybadger-Token"

      false
    end
  end
end
