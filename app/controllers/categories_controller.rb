class CategoriesController < ApplicationController
  before_filter :authenticate

  def show
    @user = current_user
    @categories = @user.categories
    @category = Category.new
    @title = @user.name + ' categories'
  end

  def create
    @category  = current_user.categories.build(params[:name])
    params[:c] = @category.inspect
    return
    if @category.save
      flash[:success] = "Category created!"
    else
      flash[:error] = "Category was not created!"
    end
    redirect_to category_path(current_user)
  end

  def edit

  end

  def destroy
  end
end