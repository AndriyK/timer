class SourcesController < ApplicationController

  before_filter :authenticate
  before_filter :authorized_user, :only => [:destroy, :edit, :update]
  before_filter :prepare_tags_id, :only=>[:create, :update]

  def show
    @user = current_user
    if params[:tag_name] && !params[:tag_name].empty?
      @sources = @user.sources.joins(:tags).where(:tags=>{:name => params[:tag_name]}).paginate(:page => params[:page], :per_page => 5)
      flash.now[:error] = "There no resources with tag: " + params[:tag_name] if @sources.empty?
    else
      @sources = @user.sources.order('created_at desc').paginate(:page => params[:page], :per_page => 5)
    end
    @title = @user.name + ' sources'
  end

  def new
    @source = Source.new
  end


  def create
    @source  = current_user.sources.build(params[:source])
    if @source.save
      flash[:success] = "Source added!"
    else
      flash[:error] = "Sorry, content wasn't added. Reason: " + @source.errors.full_messages.first
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

    def prepare_tags_id
      tags_ids = []
      if params[:source][:tags]
        tags = params[:source][:tags].split(',')
        tags.each do |tag|
          user_tag = current_user.tags.find_by_name(tag)
          unless user_tag then
            user_tag = current_user.tags.create(:name=>tag)
          end
          tags_ids << user_tag.id if user_tag
        end
        params[:source][:tag_ids] = tags_ids if tags_ids
        params[:source].delete("tags")
      end
    end

end
