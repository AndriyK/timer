# Method description
#
# * *Args*    :
#   - ++ ->
# * *Returns* :
#   -
# * *Raises* :
#   - ++ ->
#


class WorksController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:edit, :update, :destroy]
  before_filter :save_custom_date, :only => [:show, :week, :month]
  before_filter :user_works, :only => [:show, :edit, :new]
  before_filter :correct_midnight_time, :only => [:create, :update]
  before_filter :prepare_categories_catalogue, :only => [:show, :edit, :new]

  def show
    @day = true
    @work = Work.new
    @title = current_user.name
    @current_day = date
    @routines = get_suitable_routines date
  end

  def week
    @week = true
    @week_start_day = get_start_week_date
    @week_interval = get_week_dates
    @works_per_day = get_works_per_day @week_start_day, @week_start_day + 7.day
  end

  def month
    @month = true
    @month_start_day = get_start_month_date
    @works_per_day = get_works_per_day @month_start_day, @month_start_day + 1.month
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


    # Method select the user's works for user
    # is executed in 'before_filter' for show, edit, new actions
    #
    # * *Args*    :
    #   no
    # * *Returns* :
    #   nothing (set instance variable @works)
    def user_works
      @works = current_user.works.where( :from => date.midnight .. (date.midnight + 1.day - 1) ).order('"from"')
    end

    # Method check if user going to acess his own work id
    # * *Args*    :
    #   no (takes param[:id]] for check)
    # * *Returns* :
    #   nothing or redirect user to HP if work wasn't found for current user
    def authorized_user
      @work = current_user.works.find_by_id(params[:id])
      redirect_to root_path if @work.nil?
    end

    # Method return current date. Is returned current time unless it is set in session
    #
    # * *Args*    :
    #   no
    # * *Returns* :
    #   Time object
    def date
      if custom_date?
        return custom_date
      end
      Time.now.utc
    end

    # Method return session['current_date'] element,  In such way is checked that if some custom date is set
    #
    # * *Args*    :
    #   no
    # * *Returns* :
    #   session['current_date']
    def custom_date?
      session['current_date']
    end

    # Method parse date from session['current_date'] element into time object,
    #
    # * *Args*    :
    #   no
    # * *Returns* :
    #   Time object constracted from session data
    def custom_date
      parts = session[:current_date].split("-")
      Time.utc(parts[0], parts[1], parts[2])
    end

    # Method set date from params[:d] parameter to session id it is correct date,
    # (is before_filter for show, week, month actions
    #
    # * *Args*    :
    #   no (takes date from params['d'])
    # * *Returns* :
    #   nothing
    def save_custom_date
      session[:current_date] = params['d'] if params['d'] && is_correct_date(params['d'])
    end

    # Method check if provided date is correct, date appears as correct if it is date not bigger that today's date)
    #
    # * *Args*    :
    #   - +param_date+ String -> string like '2011-01-12'
    # * *Returns* :
    #   - true  -> when date is correct, otherwise NIL
    def is_correct_date param_date
      parts = param_date.split("-")
      time = Time.utc(parts[0], parts[1], parts[2])
      if time.midnight < Time.now.midnight + 1.day
        return true
      end
      rescue
      NIL
    end

    # Method return week number for date
    #
    # * *Args*    :
    #   no
    # * *Returns* :
    #   integer week number
    def get_week
      date.strftime('%W').to_i
    end

    # Method return week start date and end date interwals
    #
    # * *Args*    :
    #   no (gets the week from current date)
    # * *Returns* :
    #   string of start - end dates of the week (12 - 19.06.2012, or 30.06 - 06.07.2012)
    def get_week_dates
      wk_begin = get_start_week_date
      wk_end = get_end_week_date
      begin_format = ( wk_begin.strftime("%m") == wk_end.strftime("%m") ) ? '%d' : '%d %b'
      end_format = "%d %b %Y"
      wk_begin.strftime(begin_format) + ' - ' + wk_end.strftime(end_format)
    end

    # Method return week start date
    #
    # * *Args*    :
    #   no (gets the week from current date)
    # * *Returns* :
    #   Date object for first week day
    def get_start_week_date
      Date.commercial(get_current_year, get_week, 1)
    end

    # Method return week end date
    #
    # * *Args*    :
    #   no (gets the week from current date)
    # * *Returns* :
    #   Date object for end week day
    def get_end_week_date
      Date.commercial(get_current_year, get_week, 7)
    end

    # Method return month start date
    #
    # * *Args*    :
    #   no (gets the month from current date)
    # * *Returns* :
    #   Date object for first month day
    def get_start_month_date
      Date.civil(get_current_year, date.strftime("%m").to_i, 1)
    end

    # Method return current year
    #
    # * *Args*    :
    #   no
    # * *Returns* :
    #   Integer year number
    def get_current_year
      date.strftime("%Y").to_i
    end

    # Method return reported works duration per day for specified period of time
    #
    # * *Args*    :
    #   - +start_day+ day object-> start day for selection
    #   - +end_day+ day object-> end day for selection
    # * *Returns* :
    #   report hash of selected data, looks like report[12]=80
    def get_works_per_day start_day, end_day
      report = {}
      works = current_user.works
                          .select('duration, "from"')
                          .where(:from => start_day.midnight .. (end_day.midnight - 1))
      works.each do |work|
        day = work.from.day
        report[day] ?  report[day] += work.duration : report[day] = work.duration
      end
      report
    end

    # Method add new work formed from routine
    #
    # * *Args*    :
    #   - +routine+ object-> routine based on which should be created work
    # * *Returns* :
    #   work - builded work from routine
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

    # Method return hour from time string ("07:30")
    #
    # * *Args*    :
    #   - +time+ string-> string representation of the time
    # * *Returns* :
    #   intereger hour
    def get_hour_from_time time
       parts = time.split(":")
       parts[0].to_i if parts[0]
    end

    # Method return minutes from time string ("07:30")
    #
    # * *Args*    :
    #   - +time+ string-> string representation of the time
    # * *Returns* :
    #   intereger minutes
    def get_minute_from_time time
      parts = time.split(":")
      parts[1].to_i if parts[1]
    end

    # Method return suitable routins for current date. It works in two steps: at first, select routines for current day and week,
    # than is selected routines for defined date.
    #
    # * *Args*    :
    #   - +cur_date+ Time object-> date for which will be selected suitable routines
    # * *Returns* :
    #   the list of available routins
    def get_suitable_routines cur_date
      routins = current_user.routines
                          .where("days like '%?%' OR weeks like '%?%'", cur_date.strftime("%u").to_i, (cur_date.day%7 == 0 ? cur_date.day/7 : (cur_date.day/7 + 1) ))
                          .order('"from"')
      routins_for_date = get_routins_per_date cur_date
      (routins + routins_for_date).uniq
    end

    # Method return suitable routins for current date as base of search is taken month date.
    #
    # * *Args*    :
    #   - +cur_date+ Time object-> date for which will be selected suitable routines
    # * *Returns* :
    #   the list of available routins
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

    # Method correct midnight time for "to" value, so when it is "00:00" it is updated to "23:59"
    #
    # * *Args*    :
    #   no (time is taken from params[:work]['to(4i)'])
    # * *Returns* :
    #   no (is changed params[:work]['to(4i)'] and params[:work]['to(5i)'])
    def correct_midnight_time
      if params[:work]['to(4i)'] == '00' && params[:work]['to(5i)'] == '00'
        params[:work]['to(4i)'] = '23'
        params[:work]['to(5i)'] = '59'
      end
    end

    def prepare_categories_catalogue
      @categories = get_categories_hash
      @catalogue = {}
      set_categories_for_catalogue(0,0)
    end

    def set_categories_for_catalogue(pcat, level)
      categories = current_user.categories.where(:pcategory=>pcat).order("pcategory,name")
      categories.each do |category|
        @catalogue[category.id] = level
        set_categories_for_catalogue(category.id, level+1)
      end
    end

    def get_categories_hash
      all_categories = current_user.categories
      categories_hash = {}
      all_categories.each do |category|
        categories_hash[category.id] = category
      end
      categories_hash
    end

end
