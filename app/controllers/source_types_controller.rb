class SourceTypesController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:destroy]

  def show
    @user = current_user
    @source_types = @user.source_types
    @source_type = SourceType.new
    @title = @user.name + ' source types'
  end

  def create
    @source  = current_user.source_types.build(params[:source_type])
    if @source.save
      flash[:success] = "Source type created!"
    else
      flash[:error] = "Source was not created!"
    end
    redirect_to source_type_path(current_user)
  end

  def destroy
    @source.destroy
    redirect_back_or source_type_path(current_user)
  end


  private

    def authorized_user
      @source = current_user.source_types.find_by_id(params[:id])
      redirect_to root_path if @source.nil?
    end

end
