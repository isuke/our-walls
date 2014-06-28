class WallsController < ApplicationController
  include ApplicationHelper

  def create
    @wall = Wall.new(wall_params)
    @user = User.find(params[:id])

    ActiveRecord::Base.transaction do
      @wall.save!
      p = @wall.participate(@user)
      p.owner = true
      p.save
    end
    flash[:success] = "Create #{@wall.name}"
    redirect_to user_path current_user
  rescue
    render template: 'users/show'
  end

  def show
    @wall = Wall.find(params[:id])
    @posts = @wall.posts.paginate(page: params[:page], per_page: 20)
  end

  def destroy
    wall = Wall.find(params[:id])
    wall.destroy
    flash[:success] = "#{wall.name} deleted."
    redirect_to user_path current_user
  end

  private

    def wall_params
      params.require(:wall).permit(:name)
    end

end
