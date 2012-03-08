class Category < ActiveRecord::Base
  attr_accessible :name, :pcategory, :scope

  belongs_to :user

  validates :name, :presence => true, :length => { :maximum => 40 }

end
