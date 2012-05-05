# == Schema Information
#
# Table name: categories
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  pcategory  :integer
#  scope      :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Category < ActiveRecord::Base
  attr_accessible :name, :pcategory, :scope

  belongs_to :user
  has_and_belongs_to_many :works
  has_and_belongs_to_many :routines

  validates :name, :presence => true, :length => { :maximum => 40 }

end
