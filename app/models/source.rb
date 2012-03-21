class Source < ActiveRecord::Base
  attr_accessible :content, :tag_ids, :work_id

  belongs_to :user
  has_and_belongs_to_many :tags

  validates :content, :presence => true, :length => { :minimum => 5 }
end
