class TagsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:destroy, :edit, :update]

  def show
    @user = current_user
    @tags = @user.tags
    @tag = Tag.new
    @title = @user.name + ' tags'
    @tags_cloud = tags_cloud
  end

  def create
    @tag  = current_user.tags.build(params[:tag])
    if @tag.save
      flash[:success] = "Tag created!"
    else
      flash[:error] = "Tag was not added! Reason: " + @tag.errors.full_messages.first
    end
    redirect_to tag_path(current_user)
  end

  def update
    if @tag.update_attributes(params[:tag])
      flash[:success] = "Tag updated."
      redirect_to tag_path(current_user)
    else
      @title = "Edit tag"
      render 'edit'
    end
  end


  def destroy
    @tag.destroy
    redirect_back_or tag_path(current_user)
  end


  private

    # Method check if is viewed tag is coorect ( belongs to current user and is in DB)
    # before filter for destroy, edit, update
    #
    # * *Args*    :
    #   no (it takes tag id from params[:id])
    # * *Returns* :
    #   nothing (in case of wrong tag id user is redirected HP)
    def authorized_user
      @tag = current_user.tags.find_by_id(params[:id])
      redirect_to root_path if @tag.nil?
    end

    # Method select all user tags and count the frequency for each
    #
    # * *Args*    :
    #   no (search is for current_user.id)
    # * *Returns* :
    #   - Hash of prepared tags (tags_prepared{'tag_name'=>'2'})
    def tags_cloud
      user_tags = Tag.select('name, Count(*) as count')
                    .joins('INNER JOIN "sources_tags" ON "tags".id="sources_tags".tag_id')
                    .where('"tags".user_id = ?', current_user.id)
                    .group('name')
                    .order('count DESC')
      tags_prepared = {}
      user_tags.each do |tag|
        tags_prepared[tag.name] = tag.count.to_s
      end
      tags_prepared
    end

end
