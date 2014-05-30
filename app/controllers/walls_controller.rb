class WallsController < ApplicationController
  include ApplicationHelper

  before_action :signed_in_user, only: [:new]

  def new
    @wall = Wall.new
  end

  def create
    @wall = Wall.new(wall_params)
    @user = User.find_by(params[:id])

    User.transaction do
      @wall.save!
      @wall.participate(@user).save!
    end
    flash[:success] = "Create #{@wall.name}"
    redirect_to user_path current_user
  rescue
    render 'new'
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
