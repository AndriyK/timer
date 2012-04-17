class SessionsController < ApplicationController

#  def new
#    @title = "Sign in"
#  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])
    if user.nil?
      flash[:session_notice] = "Invalid email/password combination."
      redirect_to root_path
    else
      sign_in user
      redirect_back_or work_path(user)
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
