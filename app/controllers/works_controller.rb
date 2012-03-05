class WorksController < ApplicationController
  before_filter :authenticate

  def create
    @work  = current_user.works.build(params[:work])
    #duration
    if @work.save
      flash[:success] = "Activity added!"
    else
      flash[:error] = "Sorry, activity wasn't added."
    end
    redirect_to current_user
  end

  def destroy
  end

end
