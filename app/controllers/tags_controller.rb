class TagsController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:destroy, :edit, :update]

  def show
    @user = current_user
    @tags = @user.tags
    @tag = Tag.new
    @title = @user.name + ' tags'
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

    def authorized_user
      @tag = current_user.tags.find_by_id(params[:id])
      redirect_to root_path if @tag.nil?
    end

end
