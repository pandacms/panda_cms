module PandaCms
  class PostsController < ApplicationController
    def index
    end

    def show
      post = PandaCms::Post.find_by(slug: "/" + params[:slug])

      # TODO: Make this much nicer in future
      globals = {
        post: post,
        title: post.title
      }

      render inline: "", assigns: globals, status: :ok, layout: "layouts/post"
    end
  end
end
