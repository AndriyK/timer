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
end
