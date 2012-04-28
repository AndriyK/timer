class Routine < ActiveRecord::Base

  attr_accessible :days, :weeks, :dates, :work_id

  belongs_to :work
  belongs_to :user
end
