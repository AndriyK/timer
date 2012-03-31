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
  attr_accessible :from, :to, :duration, :description, :category_ids
  belongs_to :user
  has_and_belongs_to_many :categories

  validates :from, :to , :presence => true, :format => {:with => /201\d-(0|1)\d-\d{2} \d{2}:\d{2}:\d{2}/, :message=>"Wrong time interval"}
  validates :description, :presence => true, :length => {:in => 1..255, :message => "Description has not correct length" }
  validates :user_id, :presence => true

  before_save :set_duration

  private

    def set_duration
      from = Time.parse(self.from.to_s)
      to = Time.parse(self.to.to_s)
      self.duration = (to - from)/60
    rescue
      0
    end

end
