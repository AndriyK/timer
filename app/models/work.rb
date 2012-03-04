# == Schema Information
#
# Table name: works
#
#  id          :integer         not null, primary key
#  from        :datetime
#  to          :datetime
#  duration    :integer
#  description :string(255)
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Work < ActiveRecord::Base
  attr_accessible :from, :to, :duration, :description
  belongs_to :user

  validates :from, :presence => true
  validates :to, :presence => true
  #validates :duration, :presence => true
  validates :description, :presence => true
  validates :user_id, :presence => true
end
