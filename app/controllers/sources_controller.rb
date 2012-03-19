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
    #params['s'] = @source.inspect
    #@source.save

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
  end

end
