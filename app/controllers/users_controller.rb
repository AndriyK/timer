class UsersController < ApplicationController
  before_filter :authenticate, :only => [:show]


  def new
    @title = "Sign Up"
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  rescue
    redirect_to root_path
  end


  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Personal Time Tracker! From now you will always know how your time was spend! "
      redirect_to @user
    else
      @title = "Sign Up"
      render 'new'
    end
  end


  private

    def authenticate
      deny_access unless signed_in?
    end


end
