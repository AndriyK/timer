class WorksController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => :destroy

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
    @work.destroy
    redirect_back_or user_path(current_user)
  end


  private

    def authorized_user
      @work = current_user.works.find_by_id(params[:id])
      redirect_to root_path if @work.nil?
    end
end
