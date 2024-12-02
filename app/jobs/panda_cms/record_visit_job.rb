module Panda
  module CMS
  class RecordVisitJob < ApplicationJob
    queue_as :default

    def perform(
      url: nil,
      user_agent: nil,
      referrer: nil,
      ip_address: nil,
      page_id: nil,
      current_user_id: nil,
      params: [],
      visited_at: nil,
      redirect_id: nil
    )
      Panda::CMS::Visit.create!(
        url: url,
        user_agent: user_agent,
        referrer: referrer,
        ip_address: ip_address,
        page_id: page_id,
        redirect_id: redirect_id,
        user_id: current_user_id,
        params: params,
        visited_at: visited_at
      )
    end
  end
end
