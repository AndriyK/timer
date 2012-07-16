class CategoriesController < ApplicationController
  before_filter :authenticate
  before_filter :authorized_user, :only => [:edit, :update, :destroy]
  before_filter :prepare_pcategory, :only => [:create, :update]
  before_filter :clean_parent, :only => [:destroy]
  before_filter :set_user, :only => [:show, :edit]
  before_filter :prepare_categories_catalogue, :only => [:show, :edit]

  def show
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
      flash[:success] = "Category updated."
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

    def prepare_pcategory
      params[:category][:pcategory] = 0 if params[:category][:pcategory] == ''
    end

    def clean_parent
      current_user.categories.update_all("pcategory=0", "pcategory="+@category.id.to_s)
    end

    def prepare_categories_catalogue
      @categories = get_categories_hash
      @catalogue = {}
      set_categories_for_catalogue(0,0)
    end

    def set_categories_for_catalogue(pcat, level)
      categories = @user.categories.where(:pcategory=>pcat).order("pcategory,name")
      categories.each do |category|
        @catalogue[category.id] = level
        set_categories_for_catalogue(category.id, level+1)
      end
    end

    def get_categories_hash
      all_categories = @user.categories
      categories_hash = {}
      all_categories.each do |category|
        categories_hash[category.id] = category
      end
      categories_hash
    end

    def set_user
      @user = current_user
    end

end