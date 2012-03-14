class SourceType < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user

  validates :name, :presence => true, :length => { :maximum => 50 }
end
