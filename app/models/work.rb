# == Schema Information
#
# Table name: works
#
#  id          :integer         not null, primary key
#  date        :date
#  time        :time
#  duration    :integer
#  description :string(255)
#  user_id     :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Work < ActiveRecord::Base
  attr_accessible :date, :time, :duration, :description
  belongs_to :user

  validates :date, :presence => true
  validates :time, :presence => true
  validates :duration, :presence => true
  validates :description, :presence => true
  validates :user_id, :presence => true
end
