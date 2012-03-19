class Tag < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user
  has_and_belongs_to_many :sources

  validates :name, :presence => true, :length => { :maximum => 30 }
end
