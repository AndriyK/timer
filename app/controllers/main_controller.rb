class MainController < ApplicationController

  before_filter :redirect_user, :only => [:home]

  def home
    @title = 'Home'
  end


  private

  def redirect_user
    redirect_to user_path(current_user) if signed_in?
  end
end
