class WorksController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:edit, :update, :destroy]
  before_filter :save_custom_date, :only => [:show, :week]
  before_filter :user_works, :only => [:show, :edit, :new]

  def show
    @day = true
    @work = Work.new
    @title = current_user.name
    @current_day = date
    @routines = get_suitable_routines date
  end

  def week
    @week = true
    @current_week = get_week
    @week_interval = get_week_dates @current_week
    @week_start_day = get_start_week_date @current_week
  end

  def month
    @month = true
  end

  def new
    @current_day = date
    if params[:r_id] && (routine = current_user.routines.find_by_id(params[:r_id]) )
      @work = create_work_from_routine(routine)
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
      @works = current_user.works.where( :from => date.midnight .. (date.midnight + 1.day - 1) ).order('"from"')
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

    def get_week
      return params[:w].to_i if params[:w]
      day = date
      day.strftime('%W').to_i
    end

    def get_week_dates week
      wk_begin = get_start_week_date(week)
      wk_end = get_end_week_date(week)
      begin_format = ( wk_begin.strftime("%m") == wk_end.strftime("%m") ) ? '%d' : '%d %b'
      end_format = "%d %b %Y"
      wk_begin.strftime(begin_format) + ' - ' + wk_end.strftime(end_format)
    end

    def get_start_week_date week_number
      Date.commercial(get_current_year, week_number, 1)
    end

    def get_end_week_date week_number
      Date.commercial(get_current_year, week_number, 7)
    end

    def get_current_year
      current_date = date
      current_date.strftime("%Y").to_i
    end

    def create_work_from_routine routine
      cur_date = date
      new_work = {
        :from => Time.utc(cur_date.year, cur_date.month, cur_date.day, get_hour_from_time(routine.from), get_minute_from_time(routine.from)),
        :to => Time.utc(cur_date.year, cur_date.month, cur_date.day, get_hour_from_time(routine.to), get_minute_from_time(routine.to)),
        :description => routine.description,
        :category_ids => routine.category_ids
      }
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

    def get_suitable_routines cur_date
      routins = current_user.routines.where("days like '%?%' OR weeks like '%?%'", cur_date.strftime("%u").to_i, (cur_date.day%7 == 0 ? cur_date.day/7 : (cur_date.day/7 + 1) ))
      routins_for_date = get_routins_per_date cur_date
      (routins + routins_for_date).uniq
    end

    def get_routins_per_date cur_date
      result_routins = []
      current_user.routines.where("dates != ''").each do |routine|
        dates = routine.dates.split(",")
        dates.each do |date|
          if date.strip.include?("-")
            parts = date.strip.split("-")
            if parts[0].to_i <= cur_date.day && cur_date.day <= parts[1].to_i
              result_routins << routine
              break
            end
          elsif date.strip.to_i == cur_date.day
            result_routins << routine
            break
          end
        end
      end
      result_routins
    end

end
