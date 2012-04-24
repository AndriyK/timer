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

  validate :time_validation

  before_save :set_duration


  private

    def set_duration
      from = Time.parse(self.from.to_s)
      to = Time.parse(self.to.to_s)
      self.duration = (to - from)/60
    rescue
      0
    end

    def time_validation
      if to <= from
        errors.add(:to, "should be greater than from value")
      end
      check_intersection
    end

    def check_intersection
      user = User.find(user_id)
      user_works = user.works.where(:from => from.midnight .. (from.midnight + 1.day) )
      user_works.each do |work|
        if (from >= work.from && work.to > to)  # inside time interval
            errors.add(:base, "Times should not intersect")
        elsif (to > work.from && to < work.to) || ((from > work.from && from < work.to)) # start or ends in time interval
          errors.add(:base, "Times should not intersect!")
        elsif (from < work.from && work.to < to)
          errors.add(:base, "Times should not overwrite another intervals!")
        end
      end
    rescue
      #errors.add(:base, "some unexpected error appear")
      errors.add(:base, user_works.inspect)
    end

end
