class CategoriesController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:edit, :update, :destroy]

  def show
    @user = current_user
    @categories = @user.categories
    @category = Category.new
    @title = @user.name + ' categories'
  end

  def create
    @category  = current_user.categories.build(params[:category])
    if @category.save
      flash[:success] = "Category created!"
    else
      flash[:error] = "Category was not created!"
    end
    redirect_to category_path(current_user)
  end

  def edit
  end

  def update
    if @category.update_attributes(params[:category])
      flash[:success] = "Profile updated."
      redirect_to @category
    else
      @title = "Edit category"
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_back_or category_path(current_user)
  end


  private

    def authorized_user
      @category = current_user.categories.find_by_id(params[:id])
      redirect_to root_path if @category.nil?
    end
end