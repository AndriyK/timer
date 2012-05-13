class WorksController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:edit, :update, :destroy]
  before_filter :save_custom_date, :only => [:show]
  before_filter :user_works, :only => [:show, :edit]

  def show
    @work = Work.new
    @title = current_user.name
    @current_day = date
    @routines = current_user.routines
  end

  def new
    @current_day = date
    if params[:r_id] && (routine = current_user.routines.find_by_id(params[:r_id]) )
      @work = create_work_from_routine(routine)
      render '_fields'
    else
      redirect_to root_path
    end
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

    def user_works
      @works = current_user.works.where( :from => date .. (date + 1.day) ).order('"from"')
    end

    def authorized_user
      @work = current_user.works.find_by_id(params[:id])
      redirect_to root_path if @work.nil?
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

    def create_work_from_routine routine
      new_work = Hash.new
      cur_date = date
      new_work[:from] = Time.utc(cur_date.year, cur_date.month, cur_date.day, get_hour_from_time(routine.from), get_minute_from_time(routine.from))
      new_work[:to] = Time.utc(cur_date.year, cur_date.month, cur_date.day, get_hour_from_time(routine.to), get_minute_from_time(routine.to))
      new_work[:description] =  routine.description
      new_work[:category_ids] = routine.category_ids
      current_user.works.build( new_work )
    end

    def get_hour_from_time time
       parts = time.split(":")
       parts[0].to_i if parts[0]
    end

    def get_minute_from_time time
      parts = time.split(":")
      parts[1].to_i if parts[1]
    end

end
