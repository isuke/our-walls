class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include ApplicationHelper
  include SessionsHelper

  before_action :authorize

  private

    def authorize
      unless signed_in?
        flash[:danger] = "Please Sign up or Sign in."
        redirect_to root_path
      end
    end

end
