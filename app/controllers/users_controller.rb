class UsersController < ApplicationController

  before_action :signed_in_user, only: [:index]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Our Walls!"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to root_url
  end

  def index
    @users = User.where(['id <> ?', current_user.id])
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Before acations

    def signed_in_user
      unless signed_in?
        flash[:warning] = "Please sign in."
        redirect_to signin_url
      end
    end

end
