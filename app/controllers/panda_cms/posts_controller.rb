module PandaCms
  class PostsController < ApplicationController
    def show
      @posts_index_page = PandaCms::Page.find_by(path: "/#{PandaCms.config.posts[:prefix]}")
      @post = PandaCms::Post.find_by(slug: "/#{params[:slug]}")
      @title = @post.title

      render inline: "", status: :ok, layout: "layouts/post"
    end

    def update
      @post = Post.find(params[:id])

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
