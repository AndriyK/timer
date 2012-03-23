class UsersController < ApplicationController
  before_filter :authenticate, :only => [:show, :edit, :update]
  before_filter :correct_user, :only => [:show, :edit, :update]


  def new
    @title = "Sign Up"
    @user = User.new
  end

  def show
    @works = @user.works.where( condition )
    @work = Work.new
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

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    rescue
      redirect_to root_path
    end

    def condition
      day = date
      '"from" > \'' + day.strftime("%F") + '\' and "from" < \'' +  (day+60*60*24).strftime("%F")  + "'"
    end

    def date
      if custom_date?
         return custom_date
      end
      Time.now.utc
    end

    def custom_date?
      params['y'] && params['m'] && params['d']
    end

    def custom_date
      return Time.utc(params['y'], params['m'], params['d'])
    end

end
