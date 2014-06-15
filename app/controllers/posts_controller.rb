class PostsController < ApplicationController
  def create
    @wall = Wall.find(params[:id])
    @post = Post.new(post_params)
    if @post.save
      flash[:success] = "Add post."
    else
      flash[:danger] = "error"
    end

    redirect_to @wall
  end

  private

    def post_params
      params.require(:post).permit(:participant_id, :content)
    end
end
