module Panda
  module CMS
    class PostsController < ApplicationController
      def show
        @posts_index_page = Panda::CMS::Page.find_by(path: "/#{Panda::CMS.config.posts[:prefix]}")
        @post = Panda::CMS::Post.find_by(slug: "/#{params[:slug]}")
        @title = @post.title

        render inline: "", status: :ok, layout: "layouts/post"
      end

      def update
        @post = Post.find_by(id: params[:id])

        if @post.update(post_params)
          respond_to do |format|
            format.html { redirect_to @post, notice: "Post was successfully updated." }
            format.json { render json: {success: true} }
          end
        else
          respond_to do |format|
            format.html { render :edit }
            format.json { render json: {success: false, errors: @post.errors.full_messages} }
          end
        end
      end

      private

      def post_params
        params.require(:post).permit(
          :title,
          :slug,
          :status,
          :content,
          :post_content,
          :published_at
        )
      end
    end
  end
end
