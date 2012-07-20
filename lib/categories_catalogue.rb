module CategoriesCatalogue

  def prepare_categories_catalogue
    @categories = get_categories_hash
    @catalogue = {}
    set_categories_for_catalogue(0,0)
  end

  def set_categories_for_catalogue(pcat, level)
    categories = current_user.categories.where(:pcategory=>pcat).order("pcategory,name")
    categories.each do |category|
      @catalogue[category.id] = level
      set_categories_for_catalogue(category.id, level+1)
    end
  end

  def get_categories_hash
    all_categories = current_user.categories
    categories_hash = {}
    all_categories.each do |category|
      categories_hash[category.id] = category
    end
    categories_hash
  end

end