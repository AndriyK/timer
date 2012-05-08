class RoutinesController < ApplicationController

  before_filter :authenticate
  before_filter :authorized_user, :only => [:edit, :update, :destroy]
  before_filter :prepare_time_interval, :only =>[:create, :update]
  before_filter :prepare_routine_days, :only =>[:create, :update]

  def new
    if params[:work_id] && (work = current_user.works.find_by_id(params[:work_id]) ) then
      @routine = create_routine_from_work work
      render '_fields'
    else
      redirect_to root_path
    end
  end

  def edit
  end

  def update
    params[:routine][:category_ids] ||= []
    if @routine.update_attributes(params[:routine])
      flash[:success] = "Routine updated."
      redirect_to routine_path(current_user)
    else
      @title = "Edit routine"
      render 'edit'
    end
  end

  def create
    @routine  = current_user.routines.build(params[:routine])
    if @routine.save
      flash[:success] = "Activity added!"
    else
      flash[:error] = "Sorry, activity wasn't added. Reason: " + @routine.errors.full_messages.first
    end
    params[:t] = flash.to_s
    redirect_to routine_path(current_user)
  end

  def show
    @routines = current_user.routines
    @routine = Routine.new
  end

  def destroy
    @routine.destroy
    redirect_to routine_path(current_user)
  end


  private

    def authorized_user
      @routine = current_user.routines.find_by_id(params[:id])
      redirect_to root_path if @routine.nil?
    end

    def prepare_time_interval
      params[:routine][:from] = params[:routine][:from_hour] + ':' + params[:routine][:from_min]
      params[:routine][:to] = params[:routine][:to_hour] + ':' + params[:routine][:to_min]
    end

    def prepare_routine_days
      params[:routine][:days] = params[:routine][:days].join(',') if params[:routine][:days]
      params[:routine][:weeks] = params[:routine][:weeks].join(',') if params[:routine][:weeks]
    end

    def create_routine_from_work work
      new_routine = Hash.new
      new_routine[:description] =  work.description
      new_routine[:category_ids] = work.category_ids
      new_routine[:from] = "12:00"
      new_routine[:to] = "14:00"
      current_user.routines.build( new_routine )
    end

end
