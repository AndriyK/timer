module CategoriesHelper

  def get_category_name id
    unless id.nil?
      if (cat = Category.find_by_id( id ) )
        cat.name
      end
    end
  end

  def get_possible_parent_categories category
    possible_categories = current_user.categories
    if category.id then
      #make restriction for parent category
      possible_categories = current_user.categories.where("id != :current_category AND pcategory != :current_category", {:current_category=>category.id})
    end
    possible_categories.order("name")
  end

end

