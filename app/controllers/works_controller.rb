class WorksController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:edit, :update, :destroy]
  before_filter :save_custom_date, :only => [:show]

  def show
    @works = current_user.works.where( condition ).order("\"from\"")
    @work = Work.new
    @title = current_user.name
    @current_day = date
  end

  def create
    @work  = current_user.works.build(params[:work])
    if @work.save
      flash[:success] = "Activity added!"
    else
      flash[:error] = "Sorry, activity wasn't added. Reason: " + @work.errors.full_messages.first
    end
    redirect_to work_path(current_user)
  end

  def edit
    @works = current_user.works.where( "id <> " + @work.id.to_s + " and " + condition ).order("\"from\"")
  end

  def update
    params[:work][:category_ids] ||= []
    if @work.update_attributes(params[:work])
      flash[:success] = "Work updated."
      redirect_to work_path(current_user)
    else
      @title = "Edit work"
      render 'edit'
    end
  end

  def destroy
    @work.destroy
    redirect_to work_path(current_user)
  end


  private

    def authorized_user
      @work = current_user.works.find_by_id(params[:id])
      redirect_to root_path if @work.nil?
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
      session['current_date']
    end

    def custom_date
      parts = session[:current_date].split("-")
      Time.utc(parts[0], parts[1], parts[2])
    end

    def save_custom_date
      session[:current_date] = params['d'] if params['d']
    end

end
