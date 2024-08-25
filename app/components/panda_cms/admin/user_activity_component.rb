# frozen_string_literal: true

module PandaCms
  module Admin
    class UserActivityComponent < ViewComponent::Base
      attr_accessor :model
      attr_accessor :updated_at
      attr_accessor :user

      # @param whodunnit_to [ActiveRecord::Base] Model instance to which the user activity is related
      def initialize(whodunnit_to: nil)
        @model = whodunnit_to
        whodunnit_id = @model.versions&.last&.whodunnit
        @user = User.find(whodunnit_id) if whodunnit_id
        @updated_at = @model.updated_at
      end
    end
  end
end
