# frozen_string_literal: true

module Panda
  module CMS
  module Admin
    class PostsController < ApplicationController
      before_action :set_initial_breadcrumb, only: %i[index new edit create update]
      before_action :set_paper_trail_whodunnit, only: %i[create update]
      before_action :authenticate_admin_user!

      # Get all posts
      # @type GET
      # @return ActiveRecord::Collection A list of all posts
      def index
        posts = Panda::CMS::Post.with_user.order(:published_at)
        render :index, locals: {posts: posts}
      end

      # Loads the add post form
      # @type GET
      def new
        locals = setup_new_post_form
        render :new, locals: locals
      end

      # Loads the post editor
      # @type GET
      def edit
        add_breadcrumb post.title, edit_admin_post_path(post)
        render :edit, locals: {post: post, url: admin_post_path(post)}
      end

      # POST /admin/posts
      def create
        post = Panda::CMS::Post.new(post_params)
        post.user_id = current_user.id

        if post.save
          redirect_to edit_admin_post_path(post), notice: "The post was successfully created."
        else
          flash[:error] = "There was an error creating the post."
          locals = setup_new_post_form(post: post)
          render :new, locals: locals, status: :unprocessable_entity
        end
      end

      # @type PATCH/PUT
      # @return
      def update
        add_breadcrumb post.title, edit_admin_post_path(post)

        if post.update(post_params)
          redirect_to edit_admin_post_path(post),
            status: :see_other,
            flash: {success: "This post was successfully updated!"}
        else
          flash[:error] = "There was an error updating the post."
          render :edit, status: :unprocessable_entity
        end
      end

      private

      # Get the post from the ID
      # @type private
      # @return Panda::CMS::post
      def post
        @post ||= if params[:id]
          Panda::CMS::Post.find_by_slug("/" + params[:id])
        else
          Panda::CMS::Post.new
        end
      end

      def set_initial_breadcrumb
        add_breadcrumb "Posts", admin_posts_path
      end

      def setup_new_post_form(post: nil)
        add_breadcrumb "Add Post", new_admin_post_path

        post ||= Panda::CMS::Post.new(
          status: "active",
          published_at: Time.zone.now
        )

        {post: post, url: admin_posts_path}
      end

      # Only allow a list of trusted parameters through.
      # @type private
      # @return ActionController::StrongParameters
      def post_params
        params.require(:post).permit(:title, :slug, :post_content, :published_at, :status)
      end
    end
  end
end
