module CategoriesHelper

  def get_possible_parent_categories edited_category
    categories = []
    if @catalogue && @categories
      @catalogue.each do |id,level|
        category = @categories[id]
        if  category && (edited_category.id != category.id)
          categories << { :id=>category.id, :name=>category.name, :level=>level }
        end
      end
    end
    categories
  end

end
