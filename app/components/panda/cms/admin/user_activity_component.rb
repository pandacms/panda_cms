# frozen_string_literal: true

module Panda
  module CMS
    module Admin
      class UserActivityComponent < ViewComponent::Base
        attr_accessor :model
        attr_accessor :time
        attr_accessor :user

        # @param whodunnit_to [ActiveRecord::Base] Model instance to which the user activity is related
        def initialize(whodunnit_to: nil, at: nil, user: nil)
          if whodunnit_to
            @model = whodunnit_to
            whodunnit_id = @model.versions&.last&.whodunnit
            if whodunnit_id
              @user = User.find(whodunnit_id)
              @time = @model.updated_at
            end
          elsif user.is_a?(::Panda::CMS::User) && at.is_a?(::ActiveSupport::TimeWithZone)
            @user = user
            @time = at
          end

          if !@time
            @user = nil
            @time = nil
          end
        end
      end
    end
  end
end
