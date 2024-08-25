# frozen_string_literal: true

module PandaCms
  module Admin
    class StatisticsComponent < ViewComponent::Base
      attr_reader :metric
      attr_reader :value

      def initialize(metric:, value:)
        @metric = metric
        @value = value
      end
    end
  end
end
