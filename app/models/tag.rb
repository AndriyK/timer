# == Schema Information
#
# Table name: tags
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Tag < ActiveRecord::Base
  attr_accessible :name

  belongs_to :user
  has_and_belongs_to_many :sources

  validates :name, :presence => true, :length => { :maximum => 30 }
end
