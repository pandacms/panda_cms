# frozen_string_literal: true

module PandaCms
  module Admin
    class BlockContentsController < ApplicationController
      before_action :set_page, only: %i[update]
      before_action :set_block_content, only: %i[update]
      before_action :set_paper_trail_whodunnit, only: %i[update]
      before_action :authenticate_admin_user!

      # @type PATCH/PUT
      # @return
      def update
        if @block_content.update(block_content_params)
          @block_content.page.touch # Update the page's updated_at
          render json: @block_content, status: :ok
        else
          render json: @block_content.errors, status: :unprocessable_entity
        end
      end

      private

      # @type private
      # @return PandaCms::Page
      def set_page
        @page = PandaCms::Page.find(params[:page_id])
      end

      # @type private
      # @return PandaCms::BlockContent
      def set_block_content
        @block_content = PandaCms::BlockContent.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      # @type private
      # @return ActionController::StrongParameters
      def block_content_params
        params.require(:block_content).permit(:content)
      end
    end
  end
end
