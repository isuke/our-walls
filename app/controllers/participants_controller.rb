class ParticipantsController < ApplicationController

  def create
    @wall = Wall.find(params[:participant][:wall_id])
    user  = User.find(params[:participant][:user_id])
    @participant = Participant.new(wall_id: @wall.id,
                                   user_id: user.id)
    if @participant.save
      flash[:success] = "Welcome #{user.name}"
    end
    redirect_to request.referer
  end

  def destroy
    @wall = Wall.find(params[:participant][:wall_id])
    user  = User.find(params[:participant][:user_id])
    Participant.find(params[:id]).destroy
    flash[:success] = "See you #{user.name}."
    redirect_to request.referer
  end

end
