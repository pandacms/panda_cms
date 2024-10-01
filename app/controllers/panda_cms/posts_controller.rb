module PandaCms
  class PostsController < ApplicationController
    def show
      @posts_index_page = PandaCms::Page.find_by(path: "/#{PandaCms.posts[:prefix]}")
      @post = PandaCms::Post.find_by(slug: "/#{params[:slug]}")
      @title = @post.title

      render inline: "", status: :ok, layout: "layouts/post"
    end
  end
end
