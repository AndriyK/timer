class Tag < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user

  validates :name, :presence => true, :length => { :maximum => 30 }
end
