# frozen_string_literal: true

module PandaCms
  module Admin
    class PostsController < ApplicationController
      before_action :set_initial_breadcrumb, only: %i[index]
      # before_action :set_paper_trail_whodunnit, only: %i[create update]
      before_action :authenticate_admin_user!

      # Get all posts
      # @type GET
      # @return ActiveRecord::Collection A list of all posts
      def index
        posts = PandaCms::Post.order(:published_at)
        render :index, locals: {posts: posts}
      end

      private

      def set_initial_breadcrumb
        add_breadcrumb "Posts", admin_posts_path
      end

      private

      # Only allow a list of trusted parameters through
      # @type private
      # @return ActionController::StrongParameters
      def form_params
        params.require(:post).permit(:title, :slug, :content, :published_at)
      end
    end
  end
end
