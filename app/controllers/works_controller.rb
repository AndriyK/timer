class WorksController < ApplicationController
  before_filter :authenticate
  #before_filter :duration, :only => [:create]

  def create
    @work  = current_user.works.build(params[:work])
    duration
    if @work.save
      flash[:success] = "Activity added!"
    else
      flash[:error] = "Sorry, activity wasn't added."
    end
    redirect_to current_user
  end

  def destroy
  end


  private

    # function set duration in param array, it is counted as diff in minutes between to and from
    def duration
      #todo: move setting duration to db prefilter
      from =Time.parse(@work.from.to_s)
      to = Time.parse(@work.to.to_s)
      @work.duration = (to.to_i - from.to_i)/60
    rescue
      return 0
    end

end
