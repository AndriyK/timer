# == Schema Information
#
# Table name: routines
#
#  id          :integer         not null, primary key
#  user_id     :integer
#  from        :string(255)
#  to          :string(255)
#  description :string(255)
#  days        :string(255)
#  weeks       :string(255)
#  dates       :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Routine < ActiveRecord::Base

  attr_accessible :from, :to, :description, :days, :weeks, :dates,:category_ids

  belongs_to :user
  has_and_belongs_to_many :categories

  validates :from, :to , :presence => true, :format => {:with => /\d{2}:\d{2}/, :message=>"Wrong time interval"}
  validates :description, :presence => true, :length => {:in => 1..255, :message => "Description has not correct length" }
  validates :user_id, :presence => true

  validate :time_validation
  validate :dates_validation


  private

    def time_validation
      if to <= from
        errors.add(:to, " value should be greater than from value")
      end
    end

    def dates_validation
      unless  dates.empty?
        errors.add(:dates, " wrong format") unless dates =~ /\A\d{1,2}[\s\d,-]*/
      end
    end

end
