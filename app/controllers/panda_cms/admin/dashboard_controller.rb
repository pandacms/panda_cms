require "groupdate"
require "whois-parser"

module PandaCms
  class Admin::DashboardController < ApplicationController
    before_action :set_initial_breadcrumb, only: %i[show]
    before_action :authenticate_admin_user!

    # GET /admin
    def show
      @domain_expiry = domain_expiry
    end

    private

    def set_initial_breadcrumb
      add_breadcrumb "Dashboard", PandaCms.admin_path
    end

    def domain_expiry
      return "" if request.domain == "localhost"

      whois_record = Whois.whois(request.domain)
      if (parser = whois_record&.parser)
        " (expiry date: #{parser.expires_on&.strftime("%d %b %Y")})"
      else
        " (error parsing WHOIS data)"
      end
    end
  end
end
