# == Schema Information
#
# Table name: sources
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  work_id    :integer
#  content    :text
#  created_at :datetime
#  updated_at :datetime
#

class Source < ActiveRecord::Base
  attr_accessible :content, :tag_ids, :work_id

  belongs_to :user
  has_and_belongs_to_many :tags

  validates :content, :presence => true, :length => { :minimum => 5 }

end
