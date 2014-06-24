class UsersController < ApplicationController
  include ApplicationHelper

  skip_before_action :authorize, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Our Walls!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
    unless current_user?(@user)
      flash[:danger] = "Please sign in with the corrent user."
      redirect_to root_path
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to root_url
  end

  def index
    @name = params["search"] || ''
    @users = User.where(['id <> ?', current_user.id]).
                  where('name like ?', '%' + @name + '%').
                  order("name").
                  paginate(page: params[:page], per_page: 50)
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

end
