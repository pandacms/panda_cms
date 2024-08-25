# frozen_string_literal: true

module PandaCms
  module Admin
    class UserDisplayComponent < ViewComponent::Base
      attr_accessor :user_id, :user, :metadata

      def initialize(user_id: nil, user: nil, metadata: "")
        @user = if user.nil? && user_id.present? && PandaCms::User.find(user_id)
          PandaCms::User.find(user_id)
        else
          user
        end

        @metadata = metadata
      end
    end
  end
end
