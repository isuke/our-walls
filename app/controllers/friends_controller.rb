class FriendsController < ApplicationController
  def create
    @target_user = User.find(params[:friend][:target_user_id])
    current_user.make_friend(@target_user)
    respond_to do |format|
      format.html { redirect_to user_path }
      format.js
    end
  end

  def destroy
    @target_user = Friend.find(params[:id]).target_user
    current_user.unmake_friend(@target_user)
    respond_to do |format|
      format.html { redirect_to user_path }
      format.js
    end
  end
end
