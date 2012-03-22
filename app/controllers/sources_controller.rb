class SourcesController < ApplicationController

  before_filter :authenticate
  before_filter :authorized_user, :only => [:destroy, :edit, :update]

  def show
    @user = current_user
    @sources = @user.sources
    @source = Source.new
    @title = @user.name + ' sources'
  end

  def create
    @source  = current_user.sources.build(params[:source])
    if @source.save
      flash[:success] = "Source added!"
    else
      flash[:error] = "Sorry, source wasn't added."
    end
    redirect_to source_path(current_user)
  end

  def edit
  end

  def update
    params[:source][:tag_ids] ||= []
    params[:source][:work_id] ||= ''
    if @source.update_attributes(params[:source])
      flash[:success] = "Source updated."
      redirect_back_or source_path(current_user)
    else
      @title = "Edit source"
      render 'edit'
    end
  end

  def destroy
    @source.destroy
    redirect_back_or source_path(current_user)
  end


  private

    def authorized_user
      @source = current_user.sources.find_by_id(params[:id])
      redirect_to root_path if @source.nil?
    end

end
