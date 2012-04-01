module CategoriesHelper

  def get_category_name id
    unless id.nil?
      if (cat = Category.find_by_id( id ) )
        cat.name
      end
    end
  end

end

