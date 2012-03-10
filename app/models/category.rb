class Category < ActiveRecord::Base
  attr_accessible :name, :pcategory, :scope

  belongs_to :user
  has_and_belongs_to_many :works

  validates :name, :presence => true, :length => { :maximum => 40 }

end
