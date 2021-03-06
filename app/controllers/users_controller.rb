class UsersController < ApplicationController
  before_filter :authenticate, :only => [:show, :edit, :update]
  before_filter :correct_user, :only => [:show, :edit, :update]

  def new
    @title = "Sign Up"
    @user = User.new
  end

  def show
    @title = @user.name
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

  def edit
    @title = "Edit profile"
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit profile"
      render 'edit'
    end
  end


  private

    # Method checks if provided in GET user id is correct (user with such id is in database and is authorized)
    #
    # * *Args*    :
    #   no (user id is taken from GET - params[;id]])
    # * *Returns* :
    #   nothing (if user not correct he is returned to HP)
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    rescue
      redirect_to root_path
    end

end
