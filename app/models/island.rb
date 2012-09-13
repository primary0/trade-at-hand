class Island < ActiveRecord::Base
  validates_presence_of :name, :atoll_id
  belongs_to :atoll
  has_many :properties
  has_many :users
  
  named_scope :inhabited, :conditions => {:island_category_id => "1"}  
  default_scope :include => :atoll
end
