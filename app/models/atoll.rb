class Atoll < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  has_many :islands
  belongs_to :province
  
end
